import UIKit
import RxSwift
import RxCocoa

class ResourcesViewController: MxViewController<ResourcesIntent, ResourcesResult, ResourcesViewState, ResourcesViewModel> {

    @IBOutlet weak var manageResources: UILabel!
    @IBOutlet weak var bandwidthButton: ReachButton!
    @IBOutlet weak var ramButton: ReachButton!
    @IBOutlet weak var ramResourceGraph: ResourceGraphView!
    @IBOutlet weak var cpuResourceGraph: ResourceGraphView!
    @IBOutlet weak var netResourceGraph: ResourceGraphView!
    
    var readOnly = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageResources.text = R.string.accountStrings.account_resources_title()
        bandwidthButton.setTitle(R.string.accountStrings.account_resources_bandwidth_button(), for: .normal)
        ramButton.setTitle(R.string.accountStrings.account_resources_ram_button(), for: .normal)
        
        if (readOnly) {
            manageResources.gone()
            bandwidthButton.gone()
            ramButton.gone()
        }
    }

    override func intents() -> Observable<ResourcesIntent> {
        return Observable.merge(
            Observable.just(ResourcesIntent.idle),
            Observable.just(ResourcesIntent.idle)
        )
    }

    override func idleIntent() -> ResourcesIntent {
        return ResourcesIntent.idle
    }

    override func render(state: ResourcesViewState) {
        switch state {
        case .idle:
            print("")
        case .populate(let eosAccount, let contractAccountBalance):
            print("")
        case .navigateToManageBandwidth:
            print("")
        case .navigateToManageBandwidthWithAccountName:
            print("")
        case .navigateToManageRam:
            print("")
        case .refundProgress:
            print("")
        case .refundSuccess:
            print("")
        case .refundFailed:
            print("")
        case .refundFailedWithLog(let log):
            print("")
        }
    }

    override func provideViewModel() -> ResourcesViewModel {
        return ResourcesViewModel(initialState: ResourcesViewState.idle)
    }
}
