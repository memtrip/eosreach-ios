import Foundation

enum TransactionReceiptIntent: MxIntent {
    case idle
    case navigateToBlockExplorer(transactionId: String)
    case done
}
