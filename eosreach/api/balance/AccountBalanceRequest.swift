import Foundation
import RxSwift

protocol AccountBalanceRequest {
    func getBalance(
        contractName: String,
        accountName: String,
        symbol: String,
        eosPrice: EosPrice
    ) -> Single<Result<AccountBalanceList, BalanceError>>
}

enum BalanceError : ApiError {
    case generic
    case failedRetrievingBalance(code: Int, body: String)
}
