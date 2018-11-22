import Foundation

enum TransactionReceiptResult: MxResult {
    case idle
    case navigateToBlockExplorer(transactionId: String)
    case done
}
