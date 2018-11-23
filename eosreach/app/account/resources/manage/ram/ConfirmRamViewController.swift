import UIKit
import RxSwift
import RxCocoa

class ConfirmRamViewController : MxViewController<ConfirmRamIntent, ConfirmRamResult, ConfirmRamViewState, ConfirmRamViewModel>, TransactionReceiptDelegate {
    
    private lazy var ramBundle = {
        return self.getDestinationBundle()!.model as! RamBundle
    }()
    
    @IBOutlet weak var toolBar: ReachToolbar!
    @IBOutlet weak var confirmButton: ReachPrimaryButton!
    @IBOutlet weak var activityIndicator: ReachActivityIndicator!
    @IBOutlet weak var kbLabel: UILabel!
    @IBOutlet weak var kbValue: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceValue: UILabel!
    @IBOutlet weak var ramInstructionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setToolbar(toolbar: toolBar)
        toolBar.title = R.string.ramStrings.confirm_ram_title()
        confirmButton.setTitle(R.string.ramStrings.confirm_ram_title(), for: .normal)
        kbLabel.text = R.string.ramStrings.confirm_ram_kb_label()
        priceLabel.text = R.string.ramStrings.confirm_ram_price_label()
        ramInstructionLabel.text = R.string.ramStrings.confirm_ram_instruction_label()
    }

    override func intents() -> Observable<ConfirmRamIntent> {
        return Observable.merge(
            Observable.just(ConfirmRamIntent.idle)
        )
    }

    override func idleIntent() -> ConfirmRamIntent {
        return ConfirmRamIntent.idle
    }

    override func render(state: ConfirmRamViewState) {
        switch state {
        case .idle:
            break
        case .onProgress:
            activityIndicator.start()
            confirmButton.gone()
        case .populate:
            kbValue.text = ramBundle.kb
            let kbDoubleValue = Double(ramBundle.kb)!
            let costValue = kbDoubleValue * ramBundle.costPerKb.amount
            priceLabel.text = BalanceFormatter.formatEosBalance(amount: costValue, symbol: ramBundle.costPerKb.symbol)
        case .onSuccess(let actionReceipt):
            let transactionReceiptViewController = TransactionReceiptViewController(nib: R.nib.transactionReceiptViewController)
            transactionReceiptViewController.transactionReceiptBundle = TransactionReceiptBundle(
                actionReceipt: actionReceipt,
                contractAccountBalance: ramBundle.contractAccountBalance,
                transactionReceiptRoute: TransactionReceiptRoute.account_resources)
            transactionReceiptViewController.delegate = self
            self.present(transactionReceiptViewController, animated: true, completion: nil)
        case .genericError:
            activityIndicator.gone()
            confirmButton.visible()
        case .errorWithLog(let log):
            activityIndicator.gone()
            confirmButton.visible()
            showViewLog(viewLogHandler: { _ in
                let transactionLogViewController = TransactionLogViewController(nib: R.nib.transactionLogViewController)
                transactionLogViewController.errorLog = log
                self.present(transactionLogViewController, animated: true, completion: nil)
            })
        }
    }

    override func provideViewModel() -> ConfirmRamViewModel {
        return ConfirmRamViewModel(initialState: ConfirmRamViewState.idle)
    }
    
    func transactionConfirmed() {
        // TODO: navigate to account
    }
}
