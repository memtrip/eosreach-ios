import Foundation
import RxSwift

protocol AccountActionsRequest {

    func getActionsForAccountName(
        contractAccountBalance: ContractAccountBalance,
        position: Int,
        offset: Int
    ) -> Single<Result<AccountActionList, AccountActionsError>>
}

enum AccountActionsError : ApiError {
    case generic
}
