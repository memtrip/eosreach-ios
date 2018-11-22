import Foundation
import RxCocoa
import Material

class ManageBandwidthViewController: UIViewController, TabBarDelegate {
    
    @IBOutlet weak var toolbar: ReachToolbar!
    @IBOutlet weak var tabBar: ReachTabBar!
    @IBOutlet weak var containerView: UIView!
    
    let delegateTabItem = TabItem()
    let undelegatedTabItem = TabItem()
    let allocatedTabItem = TabItem()
    
    private lazy var delegateBandwidthViewController: DelegateBandwidthViewController = {
        return R.storyboard.main.delegatedBandwidthViewController()!
    }()
    
    private lazy var undelegateBandwidthViewController: UndelegateBandwidthViewController = {
        return R.storyboard.main.undelegatedBandwidthViewController()!
    }()
    
    private lazy var allocatedBandwidthViewController: AllocatedBandwidthViewController = {
        return R.storyboard.main.allocatedBandwidthViewController()!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolbar.title = R.string.bandwidthStrings.manage_bandwidth_title()
        setToolbar(toolbar: toolbar)
        
        delegateTabItem.title = R.string.bandwidthStrings.manage_bandwidth_delegate_tab()
        undelegatedTabItem.title = R.string.bandwidthStrings.manage_bandwidth_undelegate_tab()
        allocatedTabItem.title = R.string.bandwidthStrings.manage_bandwidth_allocated_tab()
        tabBar.tabItems = [delegateTabItem,undelegatedTabItem,allocatedTabItem]
        tabBar.setup()
        tabBar.delegate = self
        
        view.backgroundColor = Res.color.colorWindowBackground()
        replaceChildViewController(viewController: delegateBandwidthViewController)
    }
    
    private func replaceChildViewController(viewController: UIViewController) {
        addChild(viewController)
        containerView.addSubview(viewController.view)
        
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    @objc func tabBar(tabBar: TabBar, willSelect tabItem: TabItem) {
        if (tabItem == delegateTabItem) {
            self.view.endEditing(true)
            replaceChildViewController(viewController: delegateBandwidthViewController)
        } else if (tabItem == undelegatedTabItem) {
            self.view.endEditing(true)
            replaceChildViewController(viewController: undelegateBandwidthViewController)
        } else if (tabItem == allocatedTabItem) {
            self.view.endEditing(true)
            replaceChildViewController(viewController: allocatedBandwidthViewController)
        }
    }
}
