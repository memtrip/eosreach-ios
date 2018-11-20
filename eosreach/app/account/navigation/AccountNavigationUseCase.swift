import Foundation
import RxSwift

class AccountNavigationUseCase {
    
    private let accountForPublicKeyRequest = AccountsForPublicKeyRequestImpl()
    private let insertAccountsForPublicKey = InsertAccountsForPublicKey()
    private let eosKeyManager = EosKeyManagerImpl()
    
    private func getAccounts() -> Single<Result<[AccountsForPublicKey], AccountsListError>> {
        let publicKeys = eosKeyManager.getAllPublicKeys()
        return Observable.from(publicKeys).concatMap { publicKey in
            Observable.zip(
                Observable.just(publicKey),
                self.accountForPublicKeyRequest.getAccountsForKey(
                    publicKey: publicKey
                ).asObservable()
            ) { (_, response) -> AccountsForPublicKey in
                if (response.success()) {
                    return AccountsForPublicKey(
                        publicKey: publicKey,
                        accounts: response.data!.accounts)
                } else {
                    throw AccountsListError.refreshAccountsFailed
                }
            }.toArray().asSingle().map { response in
                return Result<[AccountsForPublicKey], AccountsListError>(data: response)
            }.catchErrorJustReturn(Result(error: AccountsListError.refreshAccountsFailed))
        }.asSingle().catchErrorJustReturn(Result(error: AccountsListError.refreshAccountsFailed))
    }
}

enum AccountsListError : ApiError, Error {
    case refreshAccountsFailed
    case noAccounts
}
