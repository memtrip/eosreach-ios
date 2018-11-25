import UIKit
import RxSwift
import RxCocoa

class RegisteredBlockProducersViewController
: MxViewController<RegisteredBlockProducersIntent, RegisteredBlockProducersResult, RegisteredBlockProducersViewState, RegisteredBlockProducersViewModel>, DataTableView {
    
    typealias tableViewType = RegisteredBlockProducersTableView

    @IBOutlet weak var activityIndicator: ReachActivityIndicator!
    @IBOutlet weak var errorView: ErrorView!
    @IBOutlet weak var tableView: UITableView!

    var delegate: RegisteredBlockProducersDelegate?
    
    func dataTableView() -> RegisteredBlockProducersTableView {
        return tableView as! RegisteredBlockProducersTableView
    }

    override func intents() -> Observable<RegisteredBlockProducersIntent> {
        return Observable.merge(
            Observable.just(RegisteredBlockProducersIntent.start),
            errorView.retryClick().map {
                return RegisteredBlockProducersIntent.retry
            },
            dataTableView().atBottom.map { data in
                return RegisteredBlockProducersIntent.loadMore(lastAccountName: data.owner)
            },
            dataTableView().selected.map { registeredBlockProducer in
                return RegisteredBlockProducersIntent.registeredBlockProducersSelected(registeredBlockProducer: registeredBlockProducer)
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
            errorView.populate(body: R.string.exploreStrings.explore_registered_block_producers_empty_error())
        case .onLoadMoreProgress:
            break // todo
        case .onError:
            activityIndicator.stop()
            errorView.visible()
            errorView.populate(body: R.string.exploreStrings.explore_registered_block_producers_generic_error())
        case .onLoadMoreError:
            break // todo
        case .onSuccess(let registeredBlockProducers, let more):
            activityIndicator.stop()
            tableView.visible()
            if (!more) {
                dataTableView().atEnd = true
            }
            dataTableView().populate(data: registeredBlockProducers)
        case .websiteSelected(let url):
            if let url = URL(string: url) {
                UIApplication.shared.open(url, options: [:])
            }
        case .registeredBlockProducersSelected(let registeredBlockProducer):
            if let delegate = delegate {
                delegate.selected(registeredBlockProducer: registeredBlockProducer)
            } else {
                setDestinationBundle(bundle: SegueBundle(
                    identifier: R.segue.registeredBlockProducersViewController.registeredBlockProducersToAccount.identifier,
                    model: AccountBundle(
                        accountName: registeredBlockProducer.owner,
                        readOnly: true,
                        accountPage: AccountPage.balances
                    )
                ))
                performSegue(withIdentifier: R.segue.registeredBlockProducersViewController.registeredBlockProducersToAccount, sender: self)
            }
        }
    }

    override func provideViewModel() -> RegisteredBlockProducersViewModel {
        return RegisteredBlockProducersViewModel(initialState: RegisteredBlockProducersViewState.idle)
    }
}
