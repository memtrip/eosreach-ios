import Foundation
import RxSwift

class AccountNavigationUseCase {
    
    private let accountForPublicKeyRequest = AccountsForPublicKeyRequestImpl()
    private let insertAccountsForPublicKey = InsertAccountsForPublicKey()
    private let eosKeyManager = EosKeyManagerImpl()
    
    func refreshAccounts() -> Single<Result<[AccountsForPublicKey], AccountsListError>> {
        let publicKeys = eosKeyManager.getAllPublicKeys()
        return Observable.from(publicKeys).concatMap { publicKey in
            Observable.zip(
                Observable.just(publicKey),
                self.insertAccounts(publicKey: publicKey).asObservable()
            ) { (_, response) -> AccountsForPublicKey in
                if (response.success()) {
                    return AccountsForPublicKey(
                        publicKey: publicKey,
                        accounts: response.data!.accounts)
                } else {
                    throw AccountsListError.refreshAccountsFailed
                }
            }.toArray().asSingle().map { accountsForPublicKeyList in
                let allAccounts = accountsForPublicKeyList.flatMap { accountsForPublicKey in
                    accountsForPublicKey.accounts
                }
                if (accountsForPublicKeyList.count != publicKeys.count) {
                    return Result(error: AccountsListError.refreshAccountsFailed)
                } else if (allAccounts.count == 0) {
                    return Result(error: AccountsListError.noAccounts)
                } else {
                    return Result(data: accountsForPublicKeyList)
                }
            }.catchErrorJustReturn(Result(error: AccountsListError.refreshAccountsFailed))
        }.asSingle().catchErrorJustReturn(Result(error: AccountsListError.refreshAccountsFailed))
    }
    
    private func insertAccounts(publicKey: String) -> Single<Result<AccountsForPublicKey, AccountForKeyError>> {
        return self.accountForPublicKeyRequest.getAccountsForKey(publicKey: publicKey).flatMap { response in
            if (response.success()) {
                let accountsForPublicKey = response.data!
                return self.insertAccountsForPublicKey.insertAccounts(
                    publicKey: accountsForPublicKey.publicKey,
                    accounts: accountsForPublicKey.accounts
                ).map { accountsForPublicKey in
                    return Result(data: accountsForPublicKey)
                }.catchErrorJustReturn(Result(error: AccountForKeyError.FailedRetrievingAccountList))
            } else {
                return Single.just(Result(error: AccountForKeyError.FailedRetrievingAccountList))
            }
        }.catchErrorJustReturn(Result(error: AccountForKeyError.FailedRetrievingAccountList))
    }
}

enum AccountsListError : ApiError, Error {
    case refreshAccountsFailed
    case noAccounts
}
