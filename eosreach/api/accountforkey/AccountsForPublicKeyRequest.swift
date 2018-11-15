import Foundation
import RxSwift

protocol AccountsForPublicKeyRequest {
    func getAccountsForKey(publicKey: String) -> Single<Result<AccountsForPublicKey, AccountForKeyError>>
}

enum AccountForKeyError : ApiError {
    case InvalidPrivateKey
    case PrivateKeyAlreadyImported
    case NoAccounts
    case FailedRetrievingAccountList
}
