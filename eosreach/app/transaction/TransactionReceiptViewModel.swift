import Foundation
import RxSwift

class TransactionReceiptViewModel: MxViewModel<TransactionReceiptIntent, TransactionReceiptResult, TransactionReceiptViewState> {
    
    override func dispatcher(intent: TransactionReceiptIntent) -> Observable<TransactionReceiptResult> {
        switch intent {
        case .idle:
            return just(TransactionReceiptResult.idle)
        case .navigateToBlockExplorer(let transactionId):
            return just(TransactionReceiptResult.navigateToBlockExplorer(transactionId: transactionId))
        case .done:
            return just(TransactionReceiptResult.done)
        }
    }

    override func reducer(previousState: TransactionReceiptViewState, result: TransactionReceiptResult) -> TransactionReceiptViewState {
        switch result {
        case .idle:
            return TransactionReceiptViewState.idle
        case .navigateToBlockExplorer(let transactionId):
            return TransactionReceiptViewState.navigateToBlockExplorer(transactionId: transactionId)
        case .done:
            return TransactionReceiptViewState.done
        }
    }
}
