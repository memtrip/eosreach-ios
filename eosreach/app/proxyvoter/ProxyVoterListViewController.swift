import UIKit
import RxSwift
import RxCocoa

protocol ProxyVoterListDelegate {
    func onResult(proxyVoterDetails: ProxyVoterDetails)
}

class ProxyVoterListViewController
: MxViewController<ProxyVoterListIntent, ProxyVoterListResult, ProxyVoterListViewState, ProxyVoterListViewModel>, DataTableView {

    typealias tableViewType = ProxyVoterListTableView

    func dataTableView() -> ProxyVoterListTableView {
        return proxyVoterList as! tableViewType
    }

    @IBOutlet weak var toolBar: ReachToolbar!
    @IBOutlet weak var proxyVoterList: UITableView!
    @IBOutlet weak var activityIndicator: ReachActivityIndicator!
    @IBOutlet weak var errorView: ErrorView!
    
    var delegate: ProxyVoterListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setToolbar(toolbar: toolBar)
        toolBar.title = R.string.proxyStrings.proxy_voter_list_title()
    }

    override func intents() -> Observable<ProxyVoterListIntent> {
        return Observable.merge(
            Observable.just(ProxyVoterListIntent.start),
            dataTableView().selected.map { proxyVoterDetails in
                return ProxyVoterListIntent.proxyVoterSelected(proxyVoterDetails: proxyVoterDetails)
            },
            dataTableView().atBottom.map { proxyVoterDetails in
                return ProxyVoterListIntent.loadMoreProxyVoters(lastAccount: proxyVoterDetails.owner)
            }
        )
    }

    override func idleIntent() -> ProxyVoterListIntent {
        return ProxyVoterListIntent.idle
    }

    override func render(state: ProxyVoterListViewState) {
        switch state {
        case .idle:
            break
        case .onProgress:
            activityIndicator.start()
            errorView.gone()
        case .onError:
            activityIndicator.stop()
            errorView.visible()
            errorView.populate(
                title: R.string.proxyStrings.proxy_voter_list_error_title(),
                body: R.string.proxyStrings.proxy_voter_list_error_body())
        case .onSuccess(let proxyVoterDetails):
            activityIndicator.stop()
            dataTableView().visible()
            dataTableView().populate(data: proxyVoterDetails)
        case .onMoreError:
            break // TODO
        case .onMoreProgress:
            break // TODO
        case .onMoreSuccess(let proxyVoterDetails):
            dataTableView().populate(data: proxyVoterDetails)
        case .proxyInformationSelected(let proxyVoterDetails):
            break // TODO
        case .proxyVoterSelected(let proxyVoterDetails):
            if let delegate = self.delegate {
                delegate.onResult(proxyVoterDetails: proxyVoterDetails)
                DispatchQueue.main.async {
                    self.close()
                }
            }
        }
    }

    override func provideViewModel() -> ProxyVoterListViewModel {
        return ProxyVoterListViewModel(initialState: ProxyVoterListViewState.idle)
    }
}
