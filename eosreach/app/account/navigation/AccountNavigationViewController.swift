import UIKit
import RxSwift
import RxCocoa
import SideMenu

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
    
    var delegate: AccountNavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        importKeyButton.setTitle(R.string.accountStrings.account_navigation_import_key_button(), for: .normal)
        createAccountButton.setTitle(R.string.accountStrings.account_navigation_create_account_button(), for: .normal)
        settingsButton.setTitle(R.string.accountStrings.account_navigation_settings_button(), for: .normal)
        accountsTitleLabel.text = R.string.accountStrings.account_navigation_accounts_title()
        refreshButton.setTitle(R.string.accountStrings.account_navigation_refresh_button(), for: .normal)
        tableView.backgroundColor = R.color.colorNavigationWindowBackground()
        dataTableView().cellBackgroundColor = R.color.colorNavigationWindowBackground()
        self.view.backgroundColor = R.color.colorNavigationWindowBackground()
    }

    override func intents() -> Observable<AccountNavigationIntent> {
        return Observable.merge(
            Observable.just(AccountNavigationIntent.start),
            importKeyButton.rx.tap.map {
                AccountNavigationIntent.navigateToImportKey
            },
            createAccountButton.rx.tap.map {
                AccountNavigationIntent.navigateToCreateAccount
            },
            settingsButton.rx.tap.map {
                AccountNavigationIntent.navigateToSettings
            },
            refreshButton.rx.tap.map {
                AccountNavigationIntent.refreshAccounts
            },
            dataTableView().selected.map { accountModel in
                AccountNavigationIntent.accountSelected(accountName: accountModel.accountName)
            },
            errorView.retryClick().map {
                AccountNavigationIntent.refreshAccounts
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
            dataTableView().gone()
            errorView.gone()
        case .onSuccess(let accountList):
            activityIndicator.stop()
            dataTableView().visible()
            dataTableView().clear()
            dataTableView().populate(data: accountList)
        case .onError:
            activityIndicator.stop()
            errorView.visible()
            errorView.populate(
                title: R.string.accountStrings.accounts_navigation_error_title(),
                body: R.string.accountStrings.accounts_navigation_error_body())
        case .noAccounts:
            activityIndicator.stop()
            errorView.populate(
                title: R.string.accountStrings.accounts_navigation_no_accounts_error_title(),
                body: R.string.accountStrings.accounts_navigation_no_accounts_error_body())
        case .navigateToAccount(let accountName):
            delegate?.accountsNavigationSelected(accountName: accountName)
            close()
        case .navigateToImportKey:
            delegate?.importKeyNavigationSelected()
        case .navigateToCreateAccount:
            delegate?.createAccountNavigationSelected()
        case .navigateToSettings:
            delegate?.settingsNavigationSelected()
        }
    }

    override func provideViewModel() -> AccountNavigationViewModel {
        return AccountNavigationViewModel(initialState: AccountNavigationViewState.idle)
    }
}
