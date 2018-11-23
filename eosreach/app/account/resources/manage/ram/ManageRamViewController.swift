import UIKit
import RxSwift
import RxCocoa
import Material

class ManageRamViewController : MxViewController<ManageRamIntent, ManageRamResult, ManageRamViewState, ManageRamViewModel>, TabBarDelegate {
    
    @IBOutlet weak var toolBar: ReachToolbar!
    @IBOutlet weak var ramPriceContainer: UIView!
    @IBOutlet weak var tabBar: ReachTabBar!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var ramPriceValueLabel: UILabel!
    @IBOutlet weak var ramPriceLabel: UILabel!
    @IBOutlet weak var activityIndicator: ReachActivityIndicator!
    @IBOutlet weak var errorView: ErrorView!
    
    private lazy var manageRamBundle = {
        return self.getDestinationBundle()!.model as! ManageRamBundle
    }()
    
    let buyTabItem = TabItem()
    let sellTabItem = TabItem()
    
    private lazy var buyRamViewController: BuyRamViewController = {
        return R.storyboard.main.buyRamViewController()!
    }()
    
    private lazy var sellRamViewController: SellRamViewController = {
        return R.storyboard.main.sellRamViewController()!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setToolbar(toolbar: toolBar)
        toolBar.title = R.string.ramStrings.manage_ram_title()
        ramPriceLabel.text = R.string.ramStrings.manage_ram_price_label()
        buyTabItem.title = R.string.ramStrings.manage_ram_buy_tab()
        sellTabItem.title = R.string.ramStrings.manage_ram_sell_tab()
        
        tabBar.tabItems = [buyTabItem,sellTabItem]
        tabBar.setup()
        tabBar.delegate = self
    }

    override func intents() -> Observable<ManageRamIntent> {
        return Observable.merge(
            Observable.just(ManageRamIntent.start(symbol: manageRamBundle.contractAccountBalance.balance.symbol)),
            errorView.retryClick().map {
                ManageRamIntent.start(symbol: self.manageRamBundle.contractAccountBalance.balance.symbol)
            }
        )
    }

    override func idleIntent() -> ManageRamIntent {
        return ManageRamIntent.idle
    }

    override func render(state: ManageRamViewState) {
        switch state {
        case .idle:
            break
        case .onProgress:
            activityIndicator.start()
            errorView.gone()
        case .onRamPriceError:
            activityIndicator.stop()
            errorView.visible()
            errorView.populate(
                title: R.string.ramStrings.manage_ram_error_title(),
                body: R.string.ramStrings.manage_ram_error_body())
        case .populate(let ramPricePerKb):
            activityIndicator.stop()
            ramPriceContainer.visible()
            tabBar.visible()
            containerView.visible()
            ramPriceValueLabel.text = String(ramPricePerKb.amount)
            buyRamViewController.manageRamBundle = ManageRamBundle(
                contractAccountBalance: manageRamBundle.contractAccountBalance,
                costPerKb: ramPricePerKb)
            sellRamViewController.manageRamBundle = ManageRamBundle(
                contractAccountBalance: manageRamBundle.contractAccountBalance,
                costPerKb: ramPricePerKb)
            replaceChildViewController(viewController: buyRamViewController, containerView: containerView)
        }
    }

    override func provideViewModel() -> ManageRamViewModel {
        return ManageRamViewModel(initialState: ManageRamViewState.idle)
    }
    
    @objc func tabBar(tabBar: TabBar, willSelect tabItem: TabItem) {
        if (tabItem == buyTabItem) {
            self.view.endEditing(true)
            replaceChildViewController(viewController: buyRamViewController, containerView: containerView)
        } else if (tabItem == sellTabItem) {
            self.view.endEditing(true)
            replaceChildViewController(viewController: sellRamViewController, containerView: containerView)
        }
    }
}
