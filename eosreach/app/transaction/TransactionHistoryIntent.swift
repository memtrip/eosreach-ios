import Foundation

enum TransactionHistoryIntent: MxIntent {
    case idle
    case start
    case navigateToBlockExplorer(transactionId: String)
}
