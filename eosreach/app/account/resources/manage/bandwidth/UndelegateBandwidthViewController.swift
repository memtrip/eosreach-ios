import UIKit
import RxSwift
import RxCocoa

class UndelegateBandwidthViewController
: MxViewController<UndelegateBandwidthIntent, UndelegateBandwidthResult, UndelegateBandwidthViewState, UndelegateBandwidthViewModel> {
    
    var manageBandwidthBundle: ManageBandwidthBundle?
    var prepopulated: DelegatedBandwidth?
    
    @IBOutlet weak var targetAccountTextField: ReachTextField!
    @IBOutlet weak var netAmountTextField: UITextField!
    @IBOutlet weak var cpuAmountTextField: UITextField!
    @IBOutlet weak var undelegateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        targetAccountTextField.placeholder = R.string.bandwidthStrings.delegate_bandwidth_target_account_label()
        undelegateButton.setTitle(R.string.bandwidthStrings.undelegate_bandwidth_button(), for: .normal)
    }

    override func intents() -> Observable<UndelegateBandwidthIntent> {
        return Observable.merge(
            Observable.just(UndelegateBandwidthIntent.start(manageBandwidthBundle: manageBandwidthBundle!, prepopulated: prepopulated)),
            Observable.merge(
                targetAccountTextField.rx.controlEvent(.editingDidEndOnExit).asObservable(),
                undelegateButton.rx.tap.asObservable()
            ).map {
                UndelegateBandwidthIntent.confirm(
                    toAccount: self.targetAccountTextField.text!,
                    netAmount: self.netAmountTextField.text!,
                    cpuAmount: self.cpuAmountTextField.text!,
                    contractAccountBalance: self.manageBandwidthBundle!.contractAccountBalance)
            }
        )
    }

    override func idleIntent() -> UndelegateBandwidthIntent {
        return UndelegateBandwidthIntent.idle
    }

    override func render(state: UndelegateBandwidthViewState) {
        switch state {
        case .idle:
            break
        case .populate(let manageBandwidthBundle):
            let _ = netAmountTextField.becomeFirstResponder()
            populate(manageBandwidthBundle: manageBandwidthBundle)
        case .prepopulate(let manageBandwidthBundle, let prepopulated):
            let _ = targetAccountTextField.becomeFirstResponder()
            populate(manageBandwidthBundle: manageBandwidthBundle)
            targetAccountTextField.text = prepopulated.accountName
            netAmountTextField.text = String(BalanceFormatter.deserialize(balance: prepopulated.netWeight).amount)
            cpuAmountTextField.text = String(BalanceFormatter.deserialize(balance: prepopulated.cpuWeight).amount)
        case .navigateToConfirm(let bandwidthFormBundle):
            setDestinationBundle(bundle: SegueBundle(
                identifier: R.segue.undelegateBandwidthViewController.undelegateBandwidthToConfirmBandwidth.identifier,
                model: bandwidthFormBundle
            ))
            performSegue(withIdentifier: R.segue.undelegateBandwidthViewController.undelegateBandwidthToConfirmBandwidth, sender: self)
        }
    }
    
    private func populate(manageBandwidthBundle: ManageBandwidthBundle) {
        cpuAmountTextField.placeholder = R.string.bandwidthStrings.delegate_bandwidth_cpu_amount_label(
            BalanceFormatter.formatEosBalance(balance: manageBandwidthBundle.contractAccountBalance.balance))
        netAmountTextField.placeholder = R.string.bandwidthStrings.delegate_bandwidth_net_amount_label(
            BalanceFormatter.formatEosBalance(balance: manageBandwidthBundle.contractAccountBalance.balance))
    }

    override func provideViewModel() -> UndelegateBandwidthViewModel {
        return UndelegateBandwidthViewModel(initialState: UndelegateBandwidthViewState.idle)
    }
}
