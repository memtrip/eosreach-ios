import Foundation
import RxSwift
import eosswift

class AccountActionsRequestImpl : AccountActionsRequest {

    let historyApi = HistoryApiFactory.create(rootUrl: R.string.appStrings.app_endpoint_url())

    func getActionsForAccountName(
        contractAccountBalance: ContractAccountBalance,
        position: Int,
        offset: Int
    ) -> Single<Result<AccountActionList, AccountActionsError>> {
        return historyApi.getActions(body: GetActions(
            account_name: contractAccountBalance.accountName,
            pos: position,
            offset: offset)
        ).map { response in
            if (response.success) {
                return try self.filterActionsForAccountName(
                    contractAccountBalance: contractAccountBalance,
                    historicAccountActionParent: response.body!)
            } else {
                return Result<AccountActionList, AccountActionsError>(error: .generic)
            }
            }.catchErrorJustReturn(Result<AccountActionList, AccountActionsError>(error: .generic))
    }

    private func filterActionsForAccountName(
        contractAccountBalance: ContractAccountBalance,
        historicAccountActionParent: HistoricAccountActionParent
    ) throws -> Result<AccountActionList, AccountActionsError> {
        let historicActions = historicAccountActionParent.actions.filter { action in
            return action.action_trace.act.account == contractAccountBalance.contractName &&
            action.action_trace.act.name == "transfer"
        }.distinct { historicAccountAction in
            return historicAccountAction.action_trace.trx_id
        }

        if (historicActions.count > 0) {
            return Result(
                data: AccountActionList(
                    actions: Array(try historicActions.reversed().map { historicAction in
                        try createAccountAction(
                            contractAccountBalance: contractAccountBalance,
                            action: historicAction)
                        }
                    )
                )
            )
        } else {
            return Result(data: AccountActionList(actions: []))
        }
    }

    private func createAccountAction(
        contractAccountBalance: ContractAccountBalance,
        action: HistoricAccountAction
    ) throws -> AccountAction {
        if (action.action_trace.act.name == "transfer") {
            return AccountAction.create(
                action: action,
                contractAccountBalance: contractAccountBalance)
        } else {
            throw FilterActionsError.unsupportedAction
        }
    }
}

enum FilterActionsError : Error {
    case unsupportedAction
}
