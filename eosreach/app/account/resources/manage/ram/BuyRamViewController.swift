import UIKit
import RxSwift
import RxCocoa

class BuyRamViewController : MxViewController<BuyRamIntent, BuyRamResult, BuyRamViewState, BuyRamViewModel> {
    
    @IBOutlet weak var ramAmountTextField: ReachTextField!
    @IBOutlet weak var buyRamButton: ReachPrimaryButton!
    @IBOutlet weak var estimatedValue: UILabel!
    
    var manageRamBundle: ManageRamBundle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ramAmountTextField.placeholder = R.string.ramStrings.manage_ram_amount_placeholder()
        estimatedValue.text = R.string.ramStrings.manage_ram_estimated_value_label("0")
        buyRamButton.setTitle(R.string.ramStrings.buy_ram_button(), for: .normal)
    }

    override func intents() -> Observable<BuyRamIntent> {
        return Observable.merge(
            Observable.just(BuyRamIntent.idle),
            ramAmountTextField.rx.text.asObservable().map { kb in
                if let kb = kb {
                    return BuyRamIntent.convertKiloBytesToEOSCost(kb: kb, costPerKb: self.manageRamBundle!.costPerKb!)
                } else {
                    return BuyRamIntent.idle
                }
            },
            buyRamButton.rx.tap.map {
                return BuyRamIntent.commit(kb: self.ramAmountTextField.text!)
            }
        )
    }

    override func idleIntent() -> BuyRamIntent {
        return BuyRamIntent.idle
    }

    override func render(state: BuyRamViewState) {
        switch state {
        case .idle:
            break
        case .navigateToConfirmRamForm(let kilobytes):
            setDestinationBundle(bundle: SegueBundle(
                identifier: R.segue.buyRamViewController.buyRamToConfirmRam.identifier,
                model: RamBundle(
                    contractAccountBalance: manageRamBundle!.contractAccountBalance,
                    costPerKb: manageRamBundle!.costPerKb!,
                    kb: kilobytes,
                    commitType: RamBundle.CommitType.buy
                )
            ))
            performSegue(withIdentifier: R.segue.buyRamViewController.buyRamToConfirmRam, sender: self)
        case .updateCostPerKiloByte(let eosCost):
            estimatedValue.text = R.string.ramStrings.manage_ram_estimated_value_label(eosCost)
        case .emptyRamError:
            showOKDialog(message: R.string.ramStrings.manage_ram_form_empty())
        }
    }

    override func provideViewModel() -> BuyRamViewModel {
        return BuyRamViewModel(initialState: BuyRamViewState.idle)
    }
}
