import UIKit
import RxSwift
import RxCocoa
import Material

class AccountViewController: MxViewController<AccountIntent, AccountResult, AccountViewState, AccountViewModel>, TabBarDelegate, AccountViewLayout {
    
    @IBOutlet weak var toolbar: ReachToolbar!
    @IBOutlet weak var balancesContainer: UIView!
    @IBOutlet weak var availableBalanceValueLabel: UILabel!
    @IBOutlet weak var availableBalanceLabel: UILabel!
    @IBOutlet weak var tabBar: ReachTabBar!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var activityIndicator: ReachActivityIndicator!
    @IBOutlet weak var errorView: ErrorView!
    
    private let navigationMenuItem = IconButton(image: Icon.cm.menu, tintColor: .white)
    private let navigationExploreItem = IconButton(image: Icon.cm.search, tintColor: .white)
    private let balanceTabItem = TabItem()
    private let resourcesTabItem = TabItem()
    private let voteTabItem = TabItem()
    private var loaded = false
    
    private lazy var balanceViewController: BalanceViewController = {
        return R.storyboard.main.balanceViewController()!
    }()
    
    private lazy var resourcesViewController: ResourcesViewController = {
        return R.storyboard.main.resourcesViewController()!
    }()
    
    private lazy var voteViewController: VoteViewController = {
        return R.storyboard.main.voteViewController()!
    }()
    
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
            Observable.just(AccountIntent.start(accountBundle: accountBundle, page: AccountPage.balances)),
            errorView.retryClick().map {
                return AccountIntent.retry(accountBundle: self.accountBundle)
            },
            navigationMenuItem.rx.tap.map {
                AccountIntent.openNavigation
            },
            navigationExploreItem.rx.tap.map {
                AccountIntent.navigateToExplore
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
    
    private func replaceChildViewController(viewController: UIViewController) {
        addChild(viewController)
        containerView.addSubview(viewController.view)
        
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    @objc func tabBar(tabBar: TabBar, willSelect tabItem: TabItem) {
        if (tabItem == balanceTabItem) {
            replaceChildViewController(viewController: balanceViewController)
        } else if (tabItem == resourcesTabItem) {
            replaceChildViewController(viewController: resourcesViewController)
        } else if (tabItem == voteTabItem) {
            replaceChildViewController(viewController: voteViewController)
        }
    }
    
    func populate(accountView: AccountView, page: AccountPage) {
        loaded = true
        toolbar.title = accountView.eosAccount!.accountName
        activityIndicator.stop()
        balancesContainer.visible()
        tabBar.visible()
        containerView.visible()
        
        balanceViewController.accountName = accountView.eosAccount!.accountName
        balanceViewController.accountBalanceList = accountView.balances!
        
        voteViewController.eosAccountVote = accountView.eosAccount!.eosAcconuntVote
        voteViewController.readOnly = self.accountBundle.readOnly
        
        resourcesViewController.eosAccount = accountView.eosAccount!
        resourcesViewController.readOnly = self.accountBundle.readOnly
        
        switch page {
        case .balances:
            replaceChildViewController(viewController: balanceViewController)
        case .resources:
            replaceChildViewController(viewController: resourcesViewController)
        case .vote:
            replaceChildViewController(viewController: voteViewController)
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
        errorView.gone()
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
        // TODO:
    }
    
    func navigateToExplore() {
        performSegue(withIdentifier: R.segue.accountViewController.accountToExplore, sender: self)
    }
}