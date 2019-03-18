import UIKit
import RxSwift
import RxCocoa
import Material
import SideMenu

class AccountViewController: MxViewController<AccountIntent, AccountResult, AccountViewState, AccountViewModel>, TabBarDelegate, AccountViewLayout, AccountNavigationDelegate, AccountDelegate {

    @IBOutlet weak var toolbar: ReachToolbar!
    @IBOutlet weak var balancesContainer: UIView!
    @IBOutlet weak var availableBalanceValueLabel: UILabel!
    @IBOutlet weak var availableBalanceLabel: UILabel!
    @IBOutlet weak var tabBar: ReachTabBar!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var activityIndicator: ReachActivityIndicator!
    @IBOutlet weak var errorView: ErrorView!

    private let navigationMenuItem =  IconButton(image: Icon.cm.menu, tintColor: .white).apply { it in
        it.accessibilityIdentifier = "account_menu_item"
    }
    private let navigationExploreItem = IconButton(image: Icon.cm.search, tintColor: .white).apply { it in
        it.accessibilityIdentifier = "account_search_item"
    }
    private let balanceTabItem = TabItem()
    private let resourcesTabItem = TabItem()
    private let voteTabItem = TabItem()
    private var loaded = false

    private var balanceViewController: BalanceViewController?
    private var resourcesViewController: ResourcesViewController?
    private var voteViewController: VoteViewController?

    private lazy var accountBundle = {
        return self.getDestinationBundle()!.model as! AccountBundle
    }()

    private lazy var accountRenderer: AccountRenderer = {
        return AccountRenderer(accountViewLayout: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        balanceTabItem.title = R.string.accountStrings.account_tab_balance()
        resourcesTabItem.title = R.string.accountStrings.account_tab_resources()
        voteTabItem.title = R.string.accountStrings.account_tab_vote()
        tabBar.tabItems = [balanceTabItem,resourcesTabItem,voteTabItem]
        tabBar.setup()
        tabBar.delegate = self

        if (accountBundle.readOnly) {
            setToolbar(toolbar: toolbar)
        } else {
            toolbar.leftViews.removeAll()
            toolbar.leftViews.append(navigationMenuItem)
            toolbar.rightViews.append(navigationExploreItem)
        }
    }

    override func intents() -> Observable<AccountIntent> {
        return Observable.merge(
            Observable.just(AccountIntent.start(accountBundle: accountBundle)),
            errorView.retryClick().map {
                AccountIntent.retry(accountBundle: self.accountBundle)
            },
            navigationMenuItem.rx.tap.map {
                AccountIntent.openNavigation
            },
            navigationExploreItem.rx.tap.map {
                AccountIntent.navigateToExplore
            },
            self.rx.methodInvoked(#selector(AccountViewController.importKeyNavigationSelected)).map { _ in
                AccountIntent.navigateToImportKey
            },
            self.rx.methodInvoked(#selector(AccountViewController.createAccountNavigationSelected)).map { _ in
                AccountIntent.navigateToCreateAccount
            },
            self.rx.methodInvoked(#selector(AccountViewController.settingsNavigationSelected)).map { _ in
                AccountIntent.navigateToSettings
            },
            self.rx.methodInvoked(#selector(AccountViewController.accountsNavigationSelected(accountName:))).map { accountNameInArgs in
                self.loaded = false
                return AccountIntent.refresh(accountBundle: AccountBundle(
                    accountName: accountNameInArgs[0] as! String,
                    readOnly: false,
                    accountPage: AccountPage.balances))
            },
            self.rx.methodInvoked(#selector(AccountViewController.refreshAccountVote)).map { _ in
                AccountIntent.refresh(accountBundle: AccountBundle(
                    accountName: self.accountBundle.accountName,
                    readOnly: self.accountBundle.readOnly,
                    accountPage: AccountPage.vote
                ))
            }
        )
    }

    override func idleIntent() -> AccountIntent {
        return AccountIntent.idle
    }

    override func render(state: AccountViewState) {
        accountRenderer.render(state: state)
    }

    override func provideViewModel() -> AccountViewModel {
        return AccountViewModel(initialState: AccountViewState(view: AccountViewState.View.idle))
    }

    @objc func tabBar(tabBar: TabBar, willSelect tabItem: TabItem) {
        if (tabItem == balanceTabItem) {
            replaceChildViewController(viewController: balanceViewController!, containerView: containerView)
        } else if (tabItem == resourcesTabItem) {
            replaceChildViewController(viewController: resourcesViewController!, containerView: containerView)
        } else if (tabItem == voteTabItem) {
            replaceChildViewController(viewController: voteViewController!, containerView: containerView)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination is UISideMenuNavigationController) {
            let sideMenuNavigationController = (segue.destination as! UISideMenuNavigationController)
            (sideMenuNavigationController.topViewController as! AccountNavigationViewController).delegate = self
            super.prepare(for: segue, sender: sender)
        }
    }

    //
    // MARK :- AccountDelegate
    //
    @objc dynamic func refreshAccountVote() {
    }

    //
    // MARK :- AccountNavigationDelegate
    //
    @objc dynamic func importKeyNavigationSelected() {
    }

    @objc dynamic func createAccountNavigationSelected() {
    }

    @objc dynamic func settingsNavigationSelected() {
    }

    @objc dynamic func accountsNavigationSelected(accountName: String) {
    }

    //
    // MARK :- AccountViewLayout
    //
    func populate(accountView: AccountView, page: AccountPage) {
        loaded = true
        toolbar.title = accountView.eosAccount!.accountName
        tabBar.select(at: selectAt(page: page))
        activityIndicator.stop()
        balancesContainer.visible()
        tabBar.visible()
        containerView.visible()

        let contractAccountBalance = createContractAccountBalance(accountView: accountView)

        balanceViewController = R.storyboard.main.balanceViewController()
        balanceViewController!.accountName = accountView.eosAccount!.accountName
        balanceViewController!.accountBalanceList = accountView.balances!
        balanceViewController!.readOnly = self.accountBundle.readOnly

        voteViewController = R.storyboard.main.voteViewController()
        voteViewController!.eosAccount = accountView.eosAccount
        voteViewController!.readOnly = self.accountBundle.readOnly
        voteViewController!.accountDelegate = self

        resourcesViewController = R.storyboard.main.resourcesViewController()
        resourcesViewController!.eosAccount = accountView.eosAccount!
        resourcesViewController!.contractAccountBalance = contractAccountBalance
        resourcesViewController!.readOnly = self.accountBundle.readOnly

        switch page {
        case .balances:
            replaceChildViewController(viewController: balanceViewController!, containerView: containerView)
        case .resources:
            replaceChildViewController(viewController: resourcesViewController!, containerView: containerView)
        case .vote:
            replaceChildViewController(viewController: voteViewController!, containerView: containerView)
        }
    }

    func populateTitle(title: String) {
        toolbar.title = title
    }

    func showPriceUnavailable() {
        availableBalanceValueLabel.text = R.string.accountStrings.account_available_balance_unavailable_value()
        availableBalanceLabel.text = R.string.accountStrings.account_available_balance_unavailable_label()
    }

    func showPrice(formattedPrice: String) {
        availableBalanceValueLabel.text = formattedPrice
    }

    func showProgress() {
        activityIndicator.start()
        containerView.gone()
        errorView.gone()
        balancesContainer.gone()
        tabBar.gone()
    }

    private func selectAt(page: AccountPage) -> Int {
        switch page {
        case .balances:
            return 0
        case .resources:
            return 1
        case .vote:
            return 2
        }
    }

    func showGetAccountError() {
        activityIndicator.stop()

        if (!loaded) {
            errorView.visible()
            errorView.populate(
                title: R.string.accountStrings.account_error_get_account_title(),
                body: R.string.accountStrings.account_error_get_account_body())
        } else {
            showOKDialog(title: R.string.accountStrings.account_error_get_account_title(), message: R.string.accountStrings.account_error_get_account_body())
        }
    }

    func showGetBalancesError() {
        activityIndicator.stop()
        errorView.visible()
        errorView.populate(
            title: R.string.accountStrings.account_error_get_balances_title(),
            body: R.string.accountStrings.account_error_get_balances_body())
    }

    func openNavigation() {
        performSegue(withIdentifier: R.segue.accountViewController.accountToNavigationDrawer, sender: self)
    }

    func navigateToExplore() {
        performSegue(withIdentifier: R.segue.accountViewController.accountToExplore, sender: self)
    }

    func navigateToImportKey() {
        performSegue(withIdentifier: R.segue.accountViewController.accountToImportKey, sender: self)
    }

    func navigateToCreateAccount() {
        performSegue(withIdentifier: R.segue.accountViewController.accountToCreateAccount, sender: self)
    }

    func navigateToSettings() {
        performSegue(withIdentifier: R.segue.accountViewController.accountToSettings, sender: self)
    }

    private func createContractAccountBalance(accountView: AccountView) -> ContractAccountBalance {
        if let accountBalanceList = accountView.balances {
            if (accountBalanceList.balances.isNotEmpty()) {
                return accountBalanceList.balances[0]
            } else {
                return ContractAccountBalance.unavailable()
            }
        } else {
            return ContractAccountBalance.unavailable()
        }
    }
    
    @IBAction func unwindToAccountViewController(segue: UIStoryboardSegue) {
        if (segue.identifier == R.segue.castProducersVoteViewController.unwindToAccount.identifier &&
            segue.identifier == R.segue.castProxyVoteViewController.unwindToAccount.identifier) {
            let newAccountBundle = self.getDestinationBundle()!.model as! AccountBundle
            viewModel.publish(intent: AccountIntent.start(accountBundle: newAccountBundle))
        }
    }
}
