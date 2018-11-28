import Foundation

enum TransactionHistoryViewState: MxViewState {
    case idle
    case onProgress
    case onError
    case empty
    case populate(transactionHistory: [TransactionHistoryModel])
    case navigateToBlockExplorer(transactionId: String)
}
