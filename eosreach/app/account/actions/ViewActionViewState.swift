import Foundation

enum ViewActionViewState: MxViewState {
    case idle
    case populate(accountAction: AccountAction, navigationAccountName: String)
    case viewTransactionBlockExplorer(transactionId: String)
    case navigateToAccount(accountName: String)
}
