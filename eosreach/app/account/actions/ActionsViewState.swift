import Foundation

enum ActionsViewState: MxViewState {
    case idle
    case onProgress
    case onSuccess(accountActionList: AccountActionList)
    case noResults
    case onError
    case onLoadMoreProgress
    case onLoadMoreSuccess(accountActionList: AccountActionList)
    case onLoadMoreError
    case navigateToViewAction(accountAction: AccountAction)
    case navigateToTransfer(contractAccountBalance: ContractAccountBalance)
}
