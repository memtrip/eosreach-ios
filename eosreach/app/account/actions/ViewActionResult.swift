import Foundation

enum ViewActionResult: MxResult {
    case idle
    case populate(accountAction: AccountAction, navigationAccountName: String)
    case viewTransactionBlockExplorer(transactionId: String)
    case navigateToAccount(accountName: String)
}
