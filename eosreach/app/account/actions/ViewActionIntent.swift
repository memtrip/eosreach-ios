import Foundation

enum ViewActionIntent: MxIntent {
    case idle
    case start(viewActionBundle: ViewActionBundle)
    case viewTransactionBlockExplorer(transactionId: String)
    case navigateToAccount(accountName: String)
}
