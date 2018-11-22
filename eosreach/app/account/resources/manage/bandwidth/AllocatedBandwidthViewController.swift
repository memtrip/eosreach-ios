import UIKit
import RxSwift
import RxCocoa

class AllocatedBandwidthViewController
: MxViewController<AllocatedBandwidthIntent, AllocatedBandwidthResult, AllocatedBandwidthViewState, AllocatedBandwidthViewModel> {
    
    var manageBandwidthBundle: ManageBandwidthBundle?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: ReachActivityIndicator!
    @IBOutlet weak var errorView: ErrorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func intents() -> Observable<AllocatedBandwidthIntent> {
        return Observable.merge(
            Observable.just(AllocatedBandwidthIntent.idle)
        )
    }

    override func idleIntent() -> AllocatedBandwidthIntent {
        return AllocatedBandwidthIntent.idle
    }

    override func render(state: AllocatedBandwidthViewState) {
        switch state {
        case .idle:
            break
        }
    }

    override func provideViewModel() -> AllocatedBandwidthViewModel {
        return AllocatedBandwidthViewModel(initialState: AllocatedBandwidthViewState.idle)
    }
}
