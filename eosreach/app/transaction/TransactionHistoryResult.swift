import Foundation

enum TransactionHistoryResult: MxResult {
    case idle
    case onProgress
    case onError
    case empty
    case populate(transactionHistory: [TransactionHistoryModel])
    case navigateToBlockExplorer(transactionId: String)
}
