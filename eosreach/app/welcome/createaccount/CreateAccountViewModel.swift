import Foundation
import RxSwift
import StoreKit

class CreateAccountViewModel: MxViewModel<CreateAccountIntent, CreateAccountResult, CreateAccountViewState> {

    private let eosKeyManager = EosKeyManagerImpl()
    private let eosCreateAccountRequest = EosCreateAccountRequestImpl()
    private let accountsForPublicKeyRequest = AccountsForPublicKeyRequestImpl()
    private let insertAccountsForPublicKey = InsertAccountsForPublicKey()
    private let accountListSelection = AccountListSelection()
    private let unusedPublicKey = UnusedPublicKey()
    private let unusedTransactionIdentifier = UnusedTransactionIdentifier()
    private let unusedAccountInLimbo = UnusedAccountInLimbo()
    
    override func dispatcher(intent: CreateAccountIntent) -> Observable<CreateAccountResult> {
        switch intent {
        case .idle:
            return just(CreateAccountResult.idle)
        case .startBillingConnection:
            return just(CreateAccountResult.startBillingConnection)
        case .onSKProductSuccess(let skProduct):
            return just(formatPrice(skProduct: skProduct))
        case .createAccount(let accountName):
            return just(validateAccountName(accountName: accountName))
        case .accountPurchased(let transactionId, let accountName):
            return createAccount(transactionIdentifier: transactionId, accountName: accountName)
        case .goToSettings:
            return just(CreateAccountResult.goToSettings)
        case .limboRetry:
            return createAccount(transactionIdentifier: unusedTransactionIdentifier.get(), accountName: "")
        }
    }

    override func reducer(previousState: CreateAccountViewState, result: CreateAccountResult) -> CreateAccountViewState {
        switch result {
        case .idle:
            return CreateAccountViewState.idle
        case .startBillingConnection:
            return CreateAccountViewState.startBillingConnection
        case .onSKProductSuccess(let formattedPrice, let skProduct):
            return CreateAccountViewState.onSKProductSuccess(formattedPrice: formattedPrice, skProduct: skProduct)
        case .onAccountNameValidationPassed:
            return CreateAccountViewState.onAccountNameValidationPassed
        case .onCreateAccountProgress:
            return CreateAccountViewState.onCreateAccountProgress
        case .onCreateAccountSuccess(let privateKey):
            return CreateAccountViewState.onCreateAccountSuccess(privateKey: privateKey)
        case .onCreateAccountFatalError:
            return CreateAccountViewState.onCreateAccountFatalError
        case .onCreateAccountGenericError:
            return CreateAccountViewState.onCreateAccountGenericError
        case .onCreateAccountUsernameExists:
            return CreateAccountViewState.onCreateAccountUsernameExists
        case .onCreateAccountLimbo:
            return CreateAccountViewState.onCreateAccountLimbo
        case .onImportKeyProgress:
            return CreateAccountViewState.onImportKeyProgress
        case .onImportKeyError:
            return CreateAccountViewState.onImportKeyError
        case .navigateToAccounts(let accountName):
            return CreateAccountViewState.navigateToAccounts(accountName: accountName)
        case .onAccountNameValidationFailed:
            return CreateAccountViewState.onAccountNameValidationFailed
        case .onAccountNameValidationNumberStartFailed:
            return CreateAccountViewState.onAccountNameValidationNumberStartFailed
        case .goToSettings:
            return CreateAccountViewState.goToSettings
        }
    }
    
    private func formatPrice(skProduct: SKProduct) -> CreateAccountResult {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = skProduct.priceLocale
        let formattedPrice = numberFormatter.string(from: skProduct.price)!
        return CreateAccountResult.onSKProductSuccess(formattedPrice: formattedPrice, skProduct: skProduct)
    }
    
    private func validateAccountName(accountName: String) -> CreateAccountResult {
        if (accountName.isEmpty || accountName.count != 12) {
            return CreateAccountResult.onAccountNameValidationFailed
        } else if (accountName[0] >= "0" && accountName[0] <= "9") {
            return CreateAccountResult.onAccountNameValidationNumberStartFailed
        } else {
            return CreateAccountResult.onAccountNameValidationPassed
        }
    }
    
    private func createAccount(transactionIdentifier: String, accountName: String) -> Observable<CreateAccountResult> {
        unusedTransactionIdentifier.put(value: transactionIdentifier)
        return privateKeyForNewAccount().flatMap { publicKey in
            self.eosCreateAccountRequest.createAccount(
                transactionIdentifier: transactionIdentifier,
                accountName: accountName,
                publicKey: publicKey
            ).flatMap { result in
                if (result.success()) {
                    return self.createAccountSuccess(publicKey: publicKey)
                } else {
                    return self.createAccountError(createAccountError: result.error!, publicKey: publicKey)
                }
            }.catchError { error in
                return self.verifyAccountsForPublicKey(publicKey: publicKey)
            }
        }.asObservable().startWith(CreateAccountResult.onCreateAccountProgress)
    }
    
    private func createAccountSuccess(publicKey: String) -> Single<CreateAccountResult> {
        // TODO: does limbo exist on iOS?
        // TODO: no accounts synced?
        unusedPublicKey.clear()
        unusedTransactionIdentifier.clear()
        return eosKeyManager.getPrivateKey(eosPublicKey: publicKey).map { privateKey in
            CreateAccountResult.onCreateAccountSuccess(privateKey: privateKey.base58)
        }.catchErrorJustReturn(CreateAccountResult.onCreateAccountFatalError)
    }
    
    private func createAccountError(createAccountError: EosCreateAccountError, publicKey: String) -> Single<CreateAccountResult> {
        switch createAccountError {
        case .genericError:
            return verifyAccountsForPublicKey(publicKey: publicKey)
        case .fatalError:
            return Single.just(CreateAccountResult.onCreateAccountFatalError)
        case .accountNameExists:
            return Single.just(CreateAccountResult.onCreateAccountUsernameExists)
        }
    }
    
    /**
     * If an error occurs while issuing the account, we don't want to continue creating
     * unused private keys.
     */
    private func privateKeyForNewAccount() -> Single<String> {
        if (unusedPublicKey.get().isNotEmpty()) {
            return eosKeyManager.getPrivateKey(eosPublicKey: unusedPublicKey.get()).flatMap { privateKey in
                Single.just(privateKey.publicKey.base58)
            }
        } else {
            return eosKeyManager.createEosPrivateKey().flatMap { privateKey in
                self.unusedPublicKey.put(value: privateKey.publicKey.base58)
                return self.eosKeyManager.importPrivateKey(eosPrivateKey: privateKey)
            }
        }
    }
    
    /**
     * A user might lose internet connection while creating an account, in this case the
     * account might have been created, so we check accounts for the public key. If the accounts
     * for public key request fails, the create account process is in limbo.
     */
    private func verifyAccountsForPublicKey(publicKey: String) -> Single<CreateAccountResult> {
        return accountsForPublicKeyRequest.getAccountsForKey(publicKey: publicKey).flatMap { result in
            if (result.success()) {
                if (result.data != nil && result.data!.accounts.isNotEmpty()) {
                    return self.createAccountSuccess(publicKey: publicKey)
                } else {
                    /**
                     * If no accounts are returned, we can safely assume that
                     * the account was not created and it was a legit error.
                     */
                    self.unusedAccountInLimbo.clear()
                    return Single.just(CreateAccountResult.onCreateAccountGenericError)
                }
            } else {
                /**
                 * If we cannot verify whether the current session public key has any
                 * accounts, we will display an error to the user. The user must get a
                 * successful response from accountForPublicKeyRequest before continuing.
                 */
                self.unusedAccountInLimbo.put(value: true)
                return Single.just(CreateAccountResult.onCreateAccountLimbo)
            }
        }
    }
}
