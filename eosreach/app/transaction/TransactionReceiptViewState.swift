import Foundation

enum TransactionReceiptViewState: MxViewState {
    case idle
    case navigateToBlockExplorer(transactionId: String)
    case done
}
