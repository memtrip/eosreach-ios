import UIKit
import RxSwift
import RxCocoa

class DelegateBandwidthViewController
: MxViewController<DelegateBandwidthIntent, DelegateBandwidthResult, DelegateBandwidthViewState, DelegateBandwidthViewModel> {
    
    var manageBandwidthBundle: ManageBandwidthBundle?
    
    @IBOutlet weak var targetAccountTextField: ReachTextField!
    @IBOutlet weak var netAmountTextField: ReachTextField!
    @IBOutlet weak var cpuAmountTextField: UITextField!
    @IBOutlet weak var transferSwitch: UISwitch!
    @IBOutlet weak var delegateButton: ReachPrimaryButton!
    @IBOutlet weak var transferSwitchLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        targetAccountTextField.placeholder = R.string.bandwidthStrings.delegate_bandwidth_target_account_label()
        transferSwitchLabel.text = R.string.bandwidthStrings.delegate_bandwidth_transfer_label()
        delegateButton.setTitle(R.string.bandwidthStrings.delegate_bandwidth_button(), for: .normal)
        let _ = netAmountTextField.becomeFirstResponder()
    }

    override func intents() -> Observable<DelegateBandwidthIntent> {
        return Observable.merge(
            Observable.just(DelegateBandwidthIntent.start(manageBandwidthBundle: manageBandwidthBundle!)),
            Observable.merge(
                targetAccountTextField.rx.controlEvent(.editingDidEndOnExit).asObservable(),
                delegateButton.rx.tap.asObservable()
            ).map {
                DelegateBandwidthIntent.confirm(
                    toAccount: self.targetAccountTextField.text!,
                    netAmount: self.netAmountTextField.text!,
                    cpuAmount: self.cpuAmountTextField.text!,
                    transfer: self.transferSwitch.isOn,
                    contractAccountBalance: self.manageBandwidthBundle!.contractAccountBalance)
            }
        )
    }

    override func idleIntent() -> DelegateBandwidthIntent {
        return DelegateBandwidthIntent.idle
    }

    override func render(state: DelegateBandwidthViewState) {
        switch state {
        case .idle:
            break
        case .populate(let manageBandwidthBundle):
            cpuAmountTextField.placeholder = R.string.bandwidthStrings.delegate_bandwidth_cpu_amount_label(
                BalanceFormatter.formatEosBalance(balance: manageBandwidthBundle.contractAccountBalance.balance))
            netAmountTextField.placeholder = R.string.bandwidthStrings.delegate_bandwidth_net_amount_label(
                BalanceFormatter.formatEosBalance(balance: manageBandwidthBundle.contractAccountBalance.balance))
        case .navigateToConfirm(let bandwidthFormBundle):
            print("")
        }
    }

    override func provideViewModel() -> DelegateBandwidthViewModel {
        return DelegateBandwidthViewModel(initialState: DelegateBandwidthViewState.idle)
    }
}
