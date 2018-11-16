import UIKit
import RxSwift
import RxCocoa

class RegisteredBlockProducersViewController
    : MxViewController<RegisteredBlockProducersIntent, RegisteredBlockProducersResult, RegisteredBlockProducersViewState, RegisteredBlockProducersViewModel> {

    @IBOutlet weak var activityIndicator: ReachActivityIndicator!
    @IBOutlet weak var errorView: ErrorView!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func intents() -> Observable<RegisteredBlockProducersIntent> {
        return Observable.merge(
            Observable.just(RegisteredBlockProducersIntent.start),
            errorView.retryClick().map {
                return RegisteredBlockProducersIntent.retry
            }
        )
    }

    override func idleIntent() -> RegisteredBlockProducersIntent {
        return RegisteredBlockProducersIntent.idle
    }

    override func render(state: RegisteredBlockProducersViewState) {
        switch state {
        case .idle:
            break
        case .onProgress:
            activityIndicator.start()
            errorView.gone()
            tableView.gone()
        case .empty:
            activityIndicator.stop()
            errorView.visible()
            errorView.popuate(body: R.string.exploreStrings.explore_registered_block_producers_empty_error())
        case .onLoadMoreProgress:
            break // todo
        case .onError:
            activityIndicator.stop()
            errorView.visible()
            errorView.popuate(body: R.string.exploreStrings.explore_registered_block_producers_generic_error())
        case .onLoadMoreError:
            break // todo
        case .onSuccess(let registeredBlockProducers):
            activityIndicator.stop()
            tableView.visible()
            (tableView as! RegisteredBlockProducersTableView).populate(data: registeredBlockProducers)
        case .websiteSelected(let url):
            if let url = URL(string: url) {
                UIApplication.shared.open(url, options: [:])
            }
        case .registeredBlockProducersSelected(let accountName):
            break // todo
        }
    }

    override func provideViewModel() -> RegisteredBlockProducersViewModel {
        return RegisteredBlockProducersViewModel(initialState: RegisteredBlockProducersViewState.idle)
    }
}
