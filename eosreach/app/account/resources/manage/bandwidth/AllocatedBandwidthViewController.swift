import UIKit
import RxSwift
import RxCocoa

class AllocatedBandwidthViewController
: MxViewController<AllocatedBandwidthIntent, AllocatedBandwidthResult, AllocatedBandwidthViewState, AllocatedBandwidthViewModel>, DataTableView {

    typealias tableViewType = AllocatedBandwidthTableView
    
    var manageBandwidthBundle: ManageBandwidthBundle?
    var delegate: AllocatedBandwidthDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: ReachActivityIndicator!
    @IBOutlet weak var errorView: ErrorView!
    @IBOutlet weak var noResultsLabel: UILabel!
    
    func dataTableView() -> AllocatedBandwidthTableView {
        return tableView as! tableViewType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noResultsLabel.text = R.string.bandwidthStrings.allocated_bandwidth_no_results()
    }

    override func intents() -> Observable<AllocatedBandwidthIntent> {
        return Observable.merge(
            Observable.just(AllocatedBandwidthIntent.start(accountName: manageBandwidthBundle!.accountName)),
            errorView.retryClick().map {
                return AllocatedBandwidthIntent.start(accountName: self.manageBandwidthBundle!.accountName)
            },
            dataTableView().selected.map { delegatedBandwidth in
                return AllocatedBandwidthIntent.navigateToUndelegateBandwidth(delegatedBandwidth: delegatedBandwidth)
            }
        )
    }

    override func idleIntent() -> AllocatedBandwidthIntent {
        return AllocatedBandwidthIntent.idle
    }

    override func render(state: AllocatedBandwidthViewState) {
        switch state {
        case .idle:
            break
        case .onProgress:
            activityIndicator.start()
            errorView.gone()
        case .populate(let bandwidth):
            activityIndicator.stop()
            dataTableView().visible()
            dataTableView().populate(data: bandwidth)
        case .onError:
            activityIndicator.stop()
            errorView.visible()
            errorView.populate(body: R.string.bandwidthStrings.allocated_bandwidth_error_body())
        case .empty:
            activityIndicator.gone()
            noResultsLabel.visible()
        case .navigateToUndelegateBandwidth(let delegatedBandwidth):
            delegate!.selected(delegatedBandwidth: delegatedBandwidth)
        }
    }

    override func provideViewModel() -> AllocatedBandwidthViewModel {
        return AllocatedBandwidthViewModel(initialState: AllocatedBandwidthViewState.idle)
    }
}
