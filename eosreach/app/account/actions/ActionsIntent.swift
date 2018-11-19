import Foundation

enum ActionsIntent: MxIntent {
    case idle
    case start(contractAccountBalance: ContractAccountBalance)
    case retry(contractAccountBalance: ContractAccountBalance)
    case loadMoreActions(contractAccountBalance: ContractAccountBalance, lastItem: AccountAction)
    case navigateToViewAction(accountAction: AccountAction)
    case navigateToTransfer(contractAccountBalance: ContractAccountBalance)
}
