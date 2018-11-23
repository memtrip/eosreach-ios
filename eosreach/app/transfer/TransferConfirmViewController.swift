import UIKit
import RxSwift
import RxCocoa

class TransferConfirmViewController : MxViewController<TransferConfirmIntent, TransferConfirmResult, TransferConfirmViewState, TransferConfirmViewModel>, TransactionReceiptDelegate {

    @IBOutlet weak var toolBar: ReachToolbar!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountValueLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var toValueLabel: UIButton!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var fromValueLabel: UIButton!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var confirmButton: ReachPrimaryButton!
    @IBOutlet weak var activityIndicator: ReachActivityIndicator!
    
    private lazy var transferFormBundle = {
        return self.getDestinationBundle()!.model as! TransferFormBundle
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setToolbar(toolbar: toolBar)
        toolBar.text = R.string.transferStrings.transfer_confirm_title()
        amountLabel.text = R.string.transferStrings.transfer_confirm_amount()
        toLabel.text = R.string.transferStrings.transfer_confirm_to()
        fromLabel.text = R.string.transferStrings.transfer_confirm_from()
        memoLabel.text = R.string.transferStrings.transfer_confirm_memo()
        confirmButton.setTitle(R.string.transferStrings.transfer_confirm_button(), for: .normal)
    }

    override func intents() -> Observable<TransferConfirmIntent> {
        return Observable.merge(
            Observable.just(TransferConfirmIntent.start(transferFormBundle: self.transferFormBundle)),
            confirmButton.rx.tap.map {
                TransferConfirmIntent.start(transferFormBundle: self.transferFormBundle)
            }
        )
    }

    override func idleIntent() -> TransferConfirmIntent {
        return TransferConfirmIntent.idle
    }

    override func render(state: TransferConfirmViewState) {
        switch state {
        case .idle:
            break
        case .populate(let transferFormBundle):
            amountValueLabel.text = BalanceFormatter.formatEosBalance(
                balance: BalanceFormatter.create(
                    amount: transferFormBundle.amount,
                    symbol: transferFormBundle.contractAccountBalance.balance.symbol
                )
            )
            toValueLabel.setTitle(transferFormBundle.toAccountName, for: .normal)
            fromValueLabel.setTitle(transferFormBundle.contractAccountBalance.accountName, for: .normal)
            memoTextView.text = transferFormBundle.memo
        case .onProgress:
            activityIndicator.start()
            confirmButton.gone()
        case .onSuccess(let actionReceipt):
            self.showTransactionReceipt(
                actionReceipt: actionReceipt,
                contractAccountBalance: transferFormBundle.contractAccountBalance,
                delegate: self)
        case .onError:
            activityIndicator.stop()
            confirmButton.visible()
            showOKDialog(message: R.string.transferStrings.transfer_confirm_generic_error())
        case .errorWithLog(let log):
            activityIndicator.stop()
            confirmButton.visible()
            self.showTransactionLog(log: log)
        }
    }

    override func provideViewModel() -> TransferConfirmViewModel {
        return TransferConfirmViewModel(initialState: TransferConfirmViewState.idle)
    }
    
    func transactionConfirmed() {
        performSegue(withIdentifier: R.segue.transferConfirmViewController.transferConfirmToActions, sender: self)
    }
}
