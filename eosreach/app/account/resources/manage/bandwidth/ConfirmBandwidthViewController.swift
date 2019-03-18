import UIKit
import RxSwift
import RxCocoa

class ConfirmBandwidthViewController
: MxViewController<ConfirmBandwidthIntent, ConfirmBandwidthResult, ConfirmBandwidthViewState, ConfirmBandwidthViewModel>, TransactionReceiptDelegate {
    
    @IBOutlet weak var toolBar: ReachToolbar!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var activityIndicator: ReachActivityIndicator!
    @IBOutlet weak var netLabel: UILabel!
    @IBOutlet weak var netValue: UILabel!
    @IBOutlet weak var cpuLabel: UILabel!
    @IBOutlet weak var cpuValue: UILabel!
    @IBOutlet weak var confirmButton: ReachPrimaryButton!
    @IBOutlet weak var delegateFundsPermanently: UILabel!
    @IBOutlet weak var delegateFundsPermanentlySpacer: UIView!
    
    private lazy var bandwidthFormBundle = {
        return self.getDestinationBundle()!.model as! BandwidthFormBundle
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setToolbar(toolbar: toolBar)
        toolBar.title = R.string.bandwidthStrings.confirm_delegate_title()
        toLabel.text = R.string.bandwidthStrings.confirm_delegate_to_label()
        netLabel.text = R.string.bandwidthStrings.confirm_delegate_net_label()
        cpuLabel.text = R.string.bandwidthStrings.confirm_delegate_cpu_label()
        confirmButton.setTitle(R.string.bandwidthStrings.confirm_delegate_button(), for: .normal)
        delegateFundsPermanently.text = R.string.bandwidthStrings.confirm_delegate_transfer_funds()
    }

    override func intents() -> Observable<ConfirmBandwidthIntent> {
        return Observable.merge(
            Observable.just(ConfirmBandwidthIntent.start(bandwidthFormBundle: bandwidthFormBundle)),
            confirmButton.rx.tap.map {
                ConfirmBandwidthIntent.commit(bandwidthBundle: self.bandwidthFormBundle)
            }
        )
    }

    override func idleIntent() -> ConfirmBandwidthIntent {
        return ConfirmBandwidthIntent.idle
    }

    override func render(state: ConfirmBandwidthViewState) {
        switch state {
        case .idle:
            break
        case .populate(let bandwidthFormBundle):
            accountNameLabel.text = bandwidthFormBundle.targetAccount
            netValue.text = BalanceFormatter.formatEosBalance(balance: bandwidthFormBundle.netAmount)
            cpuValue.text = BalanceFormatter.formatEosBalance(balance: bandwidthFormBundle.cpuAmount)
            switch bandwidthFormBundle.type {
            case .delegate:
                toolBar.title = R.string.bandwidthStrings.confirm_delegate_title()
            case .undelegate:
                toolBar.title = R.string.bandwidthStrings.confirm_undelegate_title()
            }
            if (bandwidthFormBundle.transfer) {
                delegateFundsPermanently.visible()
                delegateFundsPermanentlySpacer.visible()
            }
        case .onProgress:
            activityIndicator.start()
            confirmButton.gone()
        case .onError:
            activityIndicator.stop()
            confirmButton.visible()
            showOKDialog(message: R.string.bandwidthStrings.confirm_delegate_error_body())
        case .withLog(let log):
            activityIndicator.stop()
            confirmButton.visible()
            self.showTransactionLog(log: log)
        case .navigateToTransactionConfirmed(let actionReceipt):
            self.showTransactionReceipt(
                actionReceipt: actionReceipt,
                contractAccountBalance: bandwidthFormBundle.contractAccountBalance,
                delegate: self)
        }
    }

    override func provideViewModel() -> ConfirmBandwidthViewModel {
        return ConfirmBandwidthViewModel(initialState: ConfirmBandwidthViewState.idle)
    }
    
    func transactionConfirmed() {
        setDestinationBundle(bundle: SegueBundle(
            identifier: R.segue.confirmBandwidthViewController.unwindToAccount.identifier,
            model: AccountBundle(
                accountName: bandwidthFormBundle.contractAccountBalance.accountName,
                readOnly: false,
                accountPage: AccountPage.resources
            )
        ))
        performSegue(withIdentifier: R.segue.confirmBandwidthViewController.unwindToAccount, sender: self)
    }
}
