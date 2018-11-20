import UIKit
import RxSwift
import RxCocoa

class AccountNavigationViewController: MxViewController<AccountNavigationIntent, AccountNavigationResult, AccountNavigationViewState, AccountNavigationViewModel>, DataTableView {
    
    typealias tableViewType = AccountCardTableView
    
    func dataTableView() -> AccountCardTableView {
        return tableView as! tableViewType
    }

    @IBOutlet weak var importKeyButton: ReachNavigationButton!
    @IBOutlet weak var createAccountButton: ReachNavigationButton!
    @IBOutlet weak var settingsButton: ReachNavigationButton!
    @IBOutlet weak var accountsTitleLabel: UILabel!
    @IBOutlet weak var refreshButton: ReachButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: ReachActivityIndicator!
    @IBOutlet weak var errorView: ErrorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func intents() -> Observable<AccountNavigationIntent> {
        return Observable.merge(
            Observable.just(AccountNavigationIntent.start),
            importKeyButton.rx.tap.map {
                return AccountNavigationIntent.navigateToImportKey
            },
            createAccountButton.rx.tap.map {
                return AccountNavigationIntent.navigateToCreateAccount
            },
            settingsButton.rx.tap.map {
                return AccountNavigationIntent.navigateToCreateAccount
            },
            refreshButton.rx.tap.map {
                return AccountNavigationIntent.refreshAccounts
            }
        )
    }

    override func idleIntent() -> AccountNavigationIntent {
        return AccountNavigationIntent.idle
    }

    override func render(state: AccountNavigationViewState) {
        switch state {
        case .idle:
            break
        case .onProgress:
            activityIndicator.start()
        case .onSuccess(let accountList):
            activityIndicator.stop()
            dataTableView().populate(data: accountList)
        case .onError:
            activityIndicator.stop()
            errorView.populate(title: "", body: "")
        case .noAccounts:
            activityIndicator.stop()
            print("")
        case .navigateToAccount(let accountEntity):
            print("")
        case .navigateToImportKey:
            print("")
        case .navigateToCreateAccount:
            print("")
        case .navigateToSettings:
            print("")
        }
    }

    override func provideViewModel() -> AccountNavigationViewModel {
        return AccountNavigationViewModel(initialState: AccountNavigationViewState.idle)
    }
}
