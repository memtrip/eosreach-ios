import Foundation
import RxSwift
import StoreKit
import eosswift

class CreateAccountViewModel: MxViewModel<CreateAccountIntent, CreateAccountResult, CreateAccountViewState> {

    private let eosKeyManager = EosKeyManagerFactory.create()
    private let eosCreateAccountRequest = EosCreateAccountRequestImpl()
    private let accountsForPublicKeyRequest = AccountsForPublicKeyRequestImpl()
    private let insertAccountsForPublicKey = InsertAccountsForPublicKey()
    private let accountListSelection = AccountListSelection()
    private let unusedPublicKey = UnusedPublicKey()
    private let unusedTransactionIdentifier = UnusedTransactionIdentifier()
    private let unusedPublicKeyInLimbo = UnusedPublicKeyInLimbo()
    private let unusedPublicKeyNoAccountsSynced = UnusedPublicKeyNoAccountsSynced()
    private let pendingAccountNameInLimbo = PendingAccountNameInLimbo()
    
    override func dispatcher(intent: CreateAccountIntent) -> Observable<CreateAccountResult> {
        switch intent {
        case .idle:
            return just(CreateAccountResult.idle)
        case .start:
            return just(startingFlow())
        case .onSKProductSuccess(let skProduct):
            return just(formatPrice(skProduct: skProduct))
        case .purchaseAccount(let accountName):
            return purchaseAccount(accountName: accountName)
        case .accountPurchased(let transactionId, let accountName):
            return createAccount(transactionIdentifier: transactionId, accountName: accountName)
        case .goToSettings:
            return just(CreateAccountResult.goToSettings)
        case .limboRetry:
            return createAccount(transactionIdentifier: unusedTransactionIdentifier.get(), accountName: pendingAccountNameInLimbo.get())
        case .syncAccounts:
            return syncAccountsForKey()
        case .syncAccountsForPrivateKey(let privateKey):
            return syncAccountsForKey(privateKey: privateKey)
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
    
    private func startingFlow() -> CreateAccountResult {
        if (unusedPublicKeyNoAccountsSynced.get()) {
            return CreateAccountResult.onImportKeyError
        } else {
            return CreateAccountResult.startBillingConnection
        }
    }
    
    private func formatPrice(skProduct: SKProduct) -> CreateAccountResult {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = skProduct.priceLocale
        let formattedPrice = numberFormatter.string(from: skProduct.price)!
        return CreateAccountResult.onSKProductSuccess(formattedPrice: formattedPrice, skProduct: skProduct)
    }
    
    private func purchaseAccount(accountName: String) -> Observable<CreateAccountResult> {
        if (accountName.isEmpty || accountName.count != 12) {
            return just(CreateAccountResult.onAccountNameValidationFailed)
        } else if (accountName[0] >= "0" && accountName[0] <= "9") {
            return just(CreateAccountResult.onAccountNameValidationNumberStartFailed)
        } else {
            return resolveFlowState(accountName: accountName)
        }
    }
    
    private func resolveFlowState(accountName: String) -> Observable<CreateAccountResult> {
        if (unusedPublicKeyInLimbo.get()) {
            return just(CreateAccountResult.onCreateAccountLimbo)
        } else if (unusedTransactionIdentifier.get().isNotEmpty()) {
            return createAccount(
                transactionIdentifier: unusedTransactionIdentifier.get(),
                accountName: accountName)
        } else {
            return just(CreateAccountResult.onAccountNameValidationPassed)
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
                    return self.createAccountError(createAccountError: result.error!, publicKey: publicKey, accountName: accountName)
                }
            }.catchError { error in
                return self.verifyAccountsForPublicKey(publicKey: publicKey, accountName: accountName)
            }
        }.catchErrorJustReturn(CreateAccountResult.onCreateAccountGenericError)
            .asObservable().startWith(CreateAccountResult.onCreateAccountProgress)
    }
    
    private func createAccountSuccess(publicKey: String) -> Single<CreateAccountResult> {
        unusedPublicKeyInLimbo.clear()
        pendingAccountNameInLimbo.clear()
        unusedTransactionIdentifier.clear()
        unusedPublicKeyNoAccountsSynced.put(value: true)
        return eosKeyManager.getPrivateKey(eosPublicKey: publicKey).map { privateKey in
            CreateAccountResult.onCreateAccountSuccess(privateKey: privateKey.base58)
        }.catchErrorJustReturn(CreateAccountResult.onImportKeyError)
    }
    
    private func createAccountError(createAccountError: EosCreateAccountError, publicKey: String, accountName: String) -> Single<CreateAccountResult> {
        switch createAccountError {
        case .genericError:
            return verifyAccountsForPublicKey(publicKey: publicKey, accountName: accountName)
        case .fatalError:
            return verifyAccountsForPublicKey(publicKey: publicKey, accountName: accountName)
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
    private func verifyAccountsForPublicKey(publicKey: String, accountName: String) -> Single<CreateAccountResult> {
        return accountsForPublicKeyRequest.getAccountsForKey(publicKey: publicKey).flatMap { result in
            if (result.success()) {
                if (result.data != nil && result.data!.accounts.isNotEmpty()) {
                    return self.createAccountSuccess(publicKey: publicKey)
                } else {
                    /**
                     * If no accounts are returned, we can safely assume that
                     * the account was not created and it was a legit error.
                     */
                    self.unusedPublicKeyInLimbo.clear()
                    return Single.just(CreateAccountResult.onCreateAccountGenericError)
                }
            } else {
                return self.verifyAccountsForPublicKeyError(accountName: accountName)
            }
        }.catchError { it in
            return self.verifyAccountsForPublicKeyError(accountName: accountName)
        }
    }
    
    private func verifyAccountsForPublicKeyError(accountName: String) -> Single<CreateAccountResult> {
        /**
         * If we cannot verify whether the current session public key has any
         * accounts, we will display an error to the user. The user must get a
         * successful response from accountForPublicKeyRequest before continuing.
         */
        self.unusedPublicKeyInLimbo.put(value: true)
        self.pendingAccountNameInLimbo.put(value: accountName)
        return Single.just(CreateAccountResult.onCreateAccountLimbo)
    }
    
    private func syncAccountsForKey(privateKey: String = "") -> Observable<CreateAccountResult> {
        return getPrivateKey(privateKey: privateKey).flatMap { eosPrivateKey in
            return self.accountsForPublicKeyRequest.getAccountsForKey(publicKey: eosPrivateKey.publicKey.base58).flatMap { result in
                if (result.success()) {
                    if (result.data!.accounts.isEmpty) {
                        return Single.just(CreateAccountResult.onImportKeyError)
                    } else {
                        return self.insertAccounts(
                            publicKey: result.data!.publicKey,
                            accounts: result.data!.accounts)
                    }
                } else {
                    return Single.just(CreateAccountResult.onImportKeyError)
                }
            }
        }.catchErrorJustReturn(CreateAccountResult.onImportKeyError)
            .asObservable().startWith(CreateAccountResult.onImportKeyProgress)
    }
    
    private func getPrivateKey(privateKey: String = "") -> Single<EOSPrivateKey> {
        if (privateKey.isNotEmpty()) {
            let privateKey = try! EOSPrivateKey(base58: privateKey)
            return Single.just(privateKey)
        } else {
            return eosKeyManager.getPrivateKey(eosPublicKey: unusedPublicKey.get())
        }
    }
    
    private func insertAccounts(publicKey: String, accounts: [AccountNameSystemBalance]) -> Single<CreateAccountResult> {
        return insertAccountsForPublicKey.insertAccounts(publicKey: publicKey, accounts: accounts).map { _ in
            self.accountListSelection.clear()
            self.unusedPublicKey.clear()
            self.unusedPublicKeyNoAccountsSynced.clear()
            return CreateAccountResult.navigateToAccounts(accountName: accounts[0].accountName)
        }
    }
}
