import Foundation
import RxSwift

protocol AccountActionsRequest {

    func getActionsForAccountName(
        contractAccountBalance: ContractAccountBalance,
        position: Int64,
        offset: Int64
    ) -> Single<Result<AccountActionList, AccountActionsError>>
}

enum AccountActionsError : ApiError {
    case generic
}
