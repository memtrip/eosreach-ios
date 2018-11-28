import Foundation
import RxSwift

class TransactionHistoryViewModel: MxViewModel<TransactionHistoryIntent, TransactionHistoryResult, TransactionHistoryViewState> {
    
    private let getTransactionHistory = GetTransactionHistory()
    
    override func dispatcher(intent: TransactionHistoryIntent) -> Observable<TransactionHistoryResult> {
        switch intent {
        case .idle:
            return just(TransactionHistoryResult.idle)
        case .start:
            return getLocalTransactionHistory()
        case .navigateToBlockExplorer(let transactionId):
            return just(TransactionHistoryResult.navigateToBlockExplorer(transactionId: transactionId))
        }
    }

    override func reducer(previousState: TransactionHistoryViewState, result: TransactionHistoryResult) -> TransactionHistoryViewState {
        switch result {
        case .idle:
            return TransactionHistoryViewState.idle
        case .onProgress:
            return TransactionHistoryViewState.onProgress
        case .onError:
            return TransactionHistoryViewState.onError
        case .empty:
            return TransactionHistoryViewState.empty
        case .populate(let transactionHistory):
            return TransactionHistoryViewState.populate(transactionHistory: transactionHistory)
        case .navigateToBlockExplorer(let transactionId):
            return TransactionHistoryViewState.navigateToBlockExplorer(transactionId: transactionId)
        }
    }
    
    private func getLocalTransactionHistory() -> Observable<TransactionHistoryResult> {
        return getTransactionHistory.select().map { results in
            TransactionHistoryResult.populate(transactionHistory: results)
        }.catchErrorJustReturn(TransactionHistoryResult.empty)
            .asObservable()
            .startWith(TransactionHistoryResult.onError)
    }
}
