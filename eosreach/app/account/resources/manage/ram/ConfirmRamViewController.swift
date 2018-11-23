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
            Observable.just(ConfirmRamIntent.start(ramBundle: ramBundle)),
            confirmButton.rx.tap.map {
                ConfirmRamIntent.confirm(
                    accountName: self.ramBundle.contractAccountBalance.accountName,
                    kb: self.ramBundle.kb,
                    commitType: self.ramBundle.commitType)
            }
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
        case .populate(let commitType):
            let kbDoubleValue = Double(ramBundle.kb)!
            let costValue = kbDoubleValue * ramBundle.costPerKb.amount
            priceValue.text = BalanceFormatter.formatEosBalance(amount: costValue, symbol: ramBundle.costPerKb.symbol)
            kbValue.text = ramBundle.kb
            
            switch commitType {
            case .buy:
                toolBar.title = R.string.ramStrings.confirm_ram_buy_title()
            case .sell:
                toolBar.title = R.string.ramStrings.confirm_ram_sell_title()
            }
        case .onSuccess(let actionReceipt):
            self.showTransactionReceipt(
                actionReceipt: actionReceipt,
                contractAccountBalance: ramBundle.contractAccountBalance,
                delegate: self)
        case .genericError:
            activityIndicator.stop()
            confirmButton.visible()
        case .errorWithLog(let log):
            activityIndicator.stop()
            confirmButton.visible()
            showViewLog(viewLogHandler: { _ in
                self.showTransactionLog(log: log)
            })
        }
    }

    override func provideViewModel() -> ConfirmRamViewModel {
        return ConfirmRamViewModel(initialState: ConfirmRamViewState.idle)
    }
    
    func transactionConfirmed() {
        setDestinationBundle(bundle: SegueBundle(
            identifier: R.segue.confirmRamViewController.confirmRamToAccounts.identifier,
            model: AccountBundle(
                accountName: ramBundle.contractAccountBalance.accountName,
                readOnly: false,
                accountPage: AccountPage.resources
            )
        ))
        performSegue(withIdentifier: R.segue.confirmRamViewController.confirmRamToAccounts, sender: self)
    }
}
