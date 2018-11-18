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
    
    let balanceTabItem = TabItem()
    let resourcesTabItem = TabItem()
    let voteTabItem = TabItem()
    
    var loaded = false
    
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
        setToolbar(toolbar: toolbar)
        balanceTabItem.title = R.string.accountStrings.account_tab_balance()
        resourcesTabItem.title = R.string.accountStrings.account_tab_resources()
        voteTabItem.title = R.string.accountStrings.account_tab_vote()
        tabBar.tabItems = [balanceTabItem,resourcesTabItem,voteTabItem]
        tabBar.setup()
        tabBar.delegate = self
    }

    override func intents() -> Observable<AccountIntent> {
        return Observable.merge(
            Observable.just(AccountIntent.start(accountBundle: accountBundle, page: AccountPage.balances)),
            errorView.retryClick().map {
                return AccountIntent.retry(accountBundle: self.accountBundle)
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
}

protocol AccountViewLayout {
    func populate(accountView: AccountView, page: AccountPage)
    func populateTitle(title: String)
    func showPriceUnavailable()
    func showPrice(formattedPrice: String)
    func showProgress()
    func showGetAccountError()
    func showGetBalancesError()
}

class AccountRenderer {
    
    let layout: AccountViewLayout
    
    init(accountViewLayout: AccountViewLayout) {
        self.layout = accountViewLayout
    }
    
    func render(state: AccountViewState) {
        if let accountName = state.accountName {
            layout.populateTitle(title: accountName)
        }
        layoutState(state: state)
    }
    
    private func layoutState(state: AccountViewState) {
        switch state.view {
        case .idle:
            break
        case .onProgress:
            layout.showProgress()
        case .onSuccess:
            let balances = state.accountView!.balances!.balances
            let eosPrice = state.accountView!.eosPrice!
            
            self.layout.populate(accountView: state.accountView!, page: state.page)
            
            if (balances.isNotEmpty()) {
                let eosBalance = balances[0].balance.amount
                if (eosPrice.unavailable) {
                    self.layout.showPriceUnavailable()
                } else {
                    let formattedPrice = CurrencyPairFormatter.formatAmountCurrencyPairValue(amount: eosBalance, eosPrice: eosPrice)
                    self.layout.showPrice(formattedPrice: formattedPrice)
                }
            } else {
                self.layout.showPriceUnavailable()
            }
        case .onErrorFetchingAccount:
            layout.showGetAccountError()
        case .onErrorFetchingBalances:
            layout.showGetBalancesError()
        }
    }
}
