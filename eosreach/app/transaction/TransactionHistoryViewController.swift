import Foundation
import RxSwift
import UIKit

class TransactionHistoryViewController: MxViewController<TransactionHistoryIntent, TransactionHistoryResult, TransactionHistoryViewState, TransactionHistoryViewModel>, DataTableView {

    typealias tableViewType = TransactionHistoryTableView
    
    func dataTableView() -> TransactionHistoryTableView {
        return tableView as! TransactionHistoryTableView
    }
    
    @IBOutlet weak var toolBar: ReachToolbar!
    @IBOutlet weak var activityIndicator: ReachActivityIndicator!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setToolbar(toolbar: toolBar)
        toolBar.title = R.string.transactionStrings.transaction_history_title()
    }
    
    override func intents() -> Observable<TransactionHistoryIntent> {
        return Observable.merge(
            Observable.just(TransactionHistoryIntent.start),
            dataTableView().selected.map { transactionHistory in
                return TransactionHistoryIntent.navigateToBlockExplorer(transactionId: transactionHistory.transactionId)
            }
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
            activityIndicator.start()
        case .onError:
            activityIndicator.stop()
            emptyLabel.visible()
        case .empty:
            activityIndicator.stop()
            emptyLabel.visible()
        case .populate(let transactionHistory):
            dataTableView().visible()
            dataTableView().populate(data: transactionHistory)
            print("")
        case .navigateToBlockExplorer(let transactionId):
            if let url = URL(string: R.string.transactionStrings.transaction_receipt_block_explorer_url(transactionId)) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    override func provideViewModel() -> TransactionHistoryViewModel {
        return TransactionHistoryViewModel(initialState: TransactionHistoryViewState.idle)
    }
}
