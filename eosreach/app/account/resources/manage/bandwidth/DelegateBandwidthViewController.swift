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
    @IBOutlet weak var activityIndicator: ReachActivityIndicator!
    @IBOutlet weak var delegateButton: ReachPrimaryButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func intents() -> Observable<DelegateBandwidthIntent> {
        return Observable.merge(
            Observable.just(DelegateBandwidthIntent.idle)
        )
    }

    override func idleIntent() -> DelegateBandwidthIntent {
        return DelegateBandwidthIntent.idle
    }

    override func render(state: DelegateBandwidthViewState) {
        switch state {
        case .idle:
            break
        }
    }

    override func provideViewModel() -> DelegateBandwidthViewModel {
        return DelegateBandwidthViewModel(initialState: DelegateBandwidthViewState.idle)
    }
}
