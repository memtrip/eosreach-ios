import Foundation
import RxSwift
import UIKit

class TransactionHistoryViewController: MxViewController<TransactionHistoryIntent, TransactionHistoryResult, TransactionHistoryViewState, TransactionHistoryViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func intents() -> Observable<TransactionHistoryIntent> {
        return Observable.merge(
            Observable.just(TransactionHistoryIntent.idle)
        )
    }
    
    override func idleIntent() -> TransactionHistoryIntent {
        return TransactionHistoryIntent.idle
    }
    
    override func render(state: TransactionHistoryViewState) {
        switch state {
        case .idle:
            break
        case .onProgress:
            print("")
        case .onError:
            print("")
        case .empty:
            print("")
        case .populate:
            print("")
        case .navigateToBlockExplorer(let transactionId):
            print("")
        }
    }
    
    override func provideViewModel() -> TransactionHistoryViewModel {
        return TransactionHistoryViewModel(initialState: TransactionHistoryViewState.idle)
    }
}
