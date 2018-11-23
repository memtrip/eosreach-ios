import Foundation
import RxSwift
import UIKit

class TransactionReceiptViewController: MxViewController<TransactionReceiptIntent, TransactionReceiptResult, TransactionReceiptViewState, TransactionReceiptViewModel> {
    
    @IBOutlet weak var transactionReceiptTitle: UILabel!
    @IBOutlet weak var transactionReceiptInstructionLabel: UILabel!
    @IBOutlet weak var viewBlockExplorerButton: ReachButton!
    @IBOutlet weak var doneButton: ReachPrimaryButton!
    
    var transactionReceiptBundle: TransactionReceiptBundle?
    var delegate: TransactionReceiptDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transactionReceiptTitle.text = R.string.transactionStrings.transaction_receipt_title()
        transactionReceiptInstructionLabel.text = R.string.transactionStrings.transaction_receipt_body()
        viewBlockExplorerButton.setTitle(R.string.transactionStrings.transaction_receipt_view_in_block_explorer_button(), for: .normal)
        doneButton.setTitle(R.string.transactionStrings.transaction_receipt_done_button(), for: .normal)
    }
    
    override func intents() -> Observable<TransactionReceiptIntent> {
        return Observable.merge(
            doneButton.rx.tap.map {
                TransactionReceiptIntent.done
            },
            viewBlockExplorerButton.rx.tap.map {
                TransactionReceiptIntent.navigateToBlockExplorer(transactionId: self.transactionReceiptBundle!.actionReceipt.transactionId)
            }
        )
    }
    
    override func idleIntent() -> TransactionReceiptIntent {
        return TransactionReceiptIntent.idle
    }
    
    override func render(state: TransactionReceiptViewState) {
        switch state {
        case .idle:
            break
        case .navigateToBlockExplorer(let transactionId):
            if let url = URL(string: R.string.transactionStrings.transaction_receipt_block_explorer_url(transactionId)) {
                UIApplication.shared.open(url, options: [:])
            }
        case .done:
            dismiss(animated: true, completion: {
                self.delegate!.transactionConfirmed()
            })
        }
    }
    
    override func provideViewModel() -> TransactionReceiptViewModel {
        return TransactionReceiptViewModel(initialState: TransactionReceiptViewState.idle)
    }
}
