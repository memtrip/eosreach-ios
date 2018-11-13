import Foundation
import RxSwift

protocol EosAccountRequest {
    func getAccount(accountName: String) -> Single<Result<EosAccount, AccountError>>
}

enum AccountError : ApiError {
    case genericError
    case failedRetrievingAccount(code: Int, body: String)
}
