import UIKit
import RxSwift
import RxCocoa

class SellRamViewController : MxViewController<SellRamIntent, SellRamResult, SellRamViewState, SellRamViewModel> {
    
    @IBOutlet weak var ramAmountTextField: ReachTextField!
    @IBOutlet weak var sellRamButton: ReachPrimaryButton!
    @IBOutlet weak var estimatedValue: UILabel!
    
    var manageRamBundle: ManageRamBundle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ramAmountTextField.placeholder = R.string.ramStrings.manage_ram_amount_placeholder()
        estimatedValue.text = R.string.ramStrings.manage_ram_estimated_value_label("0")
        sellRamButton.setTitle(R.string.ramStrings.sell_ram_button(), for: .normal)
    }

    override func intents() -> Observable<SellRamIntent> {
        return Observable.merge(
            Observable.just(SellRamIntent.idle),
            ramAmountTextField.rx.text.asObservable().map { kb in
                if let kb = kb {
                    return SellRamIntent.convertKiloBytesToEOSCost(kb: kb, costPerKb: self.manageRamBundle!.costPerKb!)
                } else {
                    return SellRamIntent.idle
                }
            },
            sellRamButton.rx.tap.map {
                return SellRamIntent.commit(kb: self.ramAmountTextField.text!)
            }
        )
    }

    override func idleIntent() -> SellRamIntent {
        return SellRamIntent.idle
    }

    override func render(state: SellRamViewState) {
        switch state {
        case .idle:
            break
        case .navigateToConfirmRamForm(let kilobytes):
            setDestinationBundle(bundle: SegueBundle(
                identifier: R.segue.sellRamViewController.sellRamToConfirmRam.identifier,
                model: RamBundle(
                    contractAccountBalance: manageRamBundle!.contractAccountBalance,
                    costPerKb: manageRamBundle!.costPerKb!,
                    kb: kilobytes,
                    commitType: RamBundle.CommitType.sell
                )
            ))
            performSegue(withIdentifier: R.segue.sellRamViewController.sellRamToConfirmRam, sender: self)
        case .updateCostPerKiloByte(let eosCost):
            estimatedValue.text = R.string.ramStrings.manage_ram_estimated_value_label(eosCost)
        case .emptyRamError:
            showOKDialog(message: R.string.ramStrings.manage_ram_form_empty())
        }
    }

    override func provideViewModel() -> SellRamViewModel {
        return SellRamViewModel(initialState: SellRamViewState.idle)
    }
}
