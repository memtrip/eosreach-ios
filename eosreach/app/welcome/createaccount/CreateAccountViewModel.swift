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
        case .onCreateAccountSuccess(let accountName, let privateKey):
            return CreateAccountViewState.onCreateAccountSuccess(accountName: accountName, privateKey: privateKey)
        case .onCreateAccountFatalError:
            return CreateAccountViewState.onCreateAccountFatalError
        case .onCreateAccountUsernameExists:
            return CreateAccountViewState.onCreateAccountUsernameExists
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
                    return self.createAccountSuccess(accountName: accountName, publicKey: publicKey)
                } else {
                    return Single.just(self.createAccountError(createAccountError: result.error!))
                }
            }.catchError { error in
                fatalError("verifyAccountsForPublicKey")
            }
        }.asObservable().startWith(CreateAccountResult.onCreateAccountProgress)
    }
    
    private func createAccountSuccess(accountName: String, publicKey: String) -> Single<CreateAccountResult> {
        // TODO: does limbo exist on iOS?
        // TODO: no accounts synced?
        unusedPublicKey.clear()
        unusedTransactionIdentifier.clear()
        return eosKeyManager.getPrivateKey(eosPublicKey: publicKey).map { privateKey in
            CreateAccountResult.onCreateAccountSuccess(accountName: accountName, privateKey: privateKey.base58)
        }.catchErrorJustReturn(CreateAccountResult.onCreateAccountFatalError)
    }
    
    private func createAccountError(createAccountError: EosCreateAccountError) -> CreateAccountResult {
        switch createAccountError {
        case .genericError:
            fatalError("verifyAccountsForPublicKey")
        case .fatalError:
            return CreateAccountResult.onCreateAccountFatalError
        case .accountNameExists:
            return CreateAccountResult.onCreateAccountUsernameExists
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
}
