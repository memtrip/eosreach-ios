import UIKit
import RxSwift
import RxCocoa

class ActionsViewController: MxViewController<ActionsIntent, ActionsResult, ActionsViewState, ActionsViewModel>, DataTableView {

    typealias tableViewType = ActionsTableView
    
    @IBOutlet weak var toolBar: ReachToolbar!
    @IBOutlet weak var transferButton: ReachPrimaryButton!
    @IBOutlet weak var actionsTableView: UITableView!
    @IBOutlet weak var activityIndicator: ReachActivityIndicator!
    @IBOutlet weak var errorView: ErrorView!
    @IBOutlet weak var noResults: UILabel!
    
    private lazy var actionsBundle = {
        return self.getDestinationBundle()!.model as! ActionsBundle
    }()
    
    func dataTableView() -> ActionsTableView {
        return actionsTableView as! ActionsTableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toolBar.title = actionsBundle.contractAccountBalance.accountName
        setToolbar(toolbar: toolBar)
        transferButton.setTitle(R.string.accountStrings.account_actions_transfer_button(), for: .normal)
        noResults.text = R.string.accountStrings.account_actions_no_results_body()
        
        if (self.actionsBundle.readOnly) {
            transferButton.goneCollapsed()
        }
    }

    override func intents() -> Observable<ActionsIntent> {
        return Observable.merge(
            Observable.just(ActionsIntent.start(contractAccountBalance: self.actionsBundle.contractAccountBalance)),
            errorView.retryClick().map {
                ActionsIntent.retry(contractAccountBalance: self.actionsBundle.contractAccountBalance)
            },
            transferButton.rx.tap.map {
                ActionsIntent.navigateToTransfer(contractAccountBalance: self.actionsBundle.contractAccountBalance)
            },
            self.dataTableView().selected.map { accountAction in
                ActionsIntent.navigateToViewAction(accountAction: accountAction)
            },
            self.dataTableView().atBottom.map { accountAction in
                ActionsIntent.loadMoreActions(
                    contractAccountBalance: self.actionsBundle.contractAccountBalance,
                    lastItem: accountAction)
            }
        )
    }

    override func idleIntent() -> ActionsIntent {
        return ActionsIntent.idle
    }

    override func render(state: ActionsViewState) {
        switch state {
        case .idle:
            break
        case .onProgress:
            activityIndicator.start()
            errorView.gone()
        case .onSuccess(let accountActionList):
            activityIndicator.stop()
            dataTableView().visible()
            dataTableView().populate(data: accountActionList.actions)
        case .noResults:
            activityIndicator.stop()
            noResults.visible()
        case .onError:
            activityIndicator.stop()
            errorView.visible()
            errorView.populate(
                title: R.string.accountStrings.account_actions_generic_error_title(),
                body: R.string.accountStrings.account_actions_generic_error_body())
        case .onLoadMoreProgress:
            break // todo
        case .onLoadMoreSuccess(let accountActionList):
            if (accountActionList.actions.count == 0) {
                dataTableView().atEnd = true
            } else {
                dataTableView().populate(data: accountActionList.actions)
            }
        case .onLoadMoreError:
            break // todo
        case .navigateToViewAction(let accountAction):
            setDestinationBundle(bundle: SegueBundle(
                identifier: R.segue.actionsViewController.actionsToViewAction.identifier,
                model: ViewActionBundle(accountAction: accountAction)))
            performSegue(withIdentifier: R.segue.actionsViewController.actionsToViewAction, sender: self)
        case .navigateToTransfer(let contractAccountBalance):
            setDestinationBundle(bundle: SegueBundle(
                identifier: R.segue.actionsViewController.actionsToTransfer.identifier,
                model: TransferBundle(contractAccountBalance: contractAccountBalance)
            ))
            performSegue(withIdentifier: R.segue.actionsViewController.actionsToTransfer, sender: self)
        }
    }

    override func provideViewModel() -> ActionsViewModel {
        return ActionsViewModel(initialState: ActionsViewState.idle)
    }
}
