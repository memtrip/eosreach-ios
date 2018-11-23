import Foundation
import RxCocoa
import Material

class ManageBandwidthViewController: UIViewController, TabBarDelegate, AllocatedBandwidthDelegate {
    
    @IBOutlet weak var toolbar: ReachToolbar!
    @IBOutlet weak var tabBar: ReachTabBar!
    @IBOutlet weak var containerView: UIView!
    
    var manageBandwidthBundle: ManageBandwidthBundle?
    
    private let delegateTabItem = TabItem()
    private let undelegatedTabItem = TabItem()
    private let allocatedTabItem = TabItem()
    
    private lazy var delegateBandwidthViewController: DelegateBandwidthViewController = {
        let delegateBandwidthViewController = R.storyboard.main.delegatedBandwidthViewController()!
        delegateBandwidthViewController.manageBandwidthBundle = self.manageBandwidthBundle!
        return delegateBandwidthViewController
    }()
    
    private lazy var undelegateBandwidthViewController: UndelegateBandwidthViewController = {
        return createUndelegateBandwidthViewController()
    }()
    
    private lazy var allocatedBandwidthViewController: AllocatedBandwidthViewController = {
        let allocatedBandwidthViewController = R.storyboard.main.allocatedBandwidthViewController()!
        allocatedBandwidthViewController.manageBandwidthBundle = manageBandwidthBundle!
        allocatedBandwidthViewController.delegate = self
        return allocatedBandwidthViewController
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
        replaceChildViewController(viewController: delegateBandwidthViewController, containerView: containerView)
    }
    
    @objc func tabBar(tabBar: TabBar, willSelect tabItem: TabItem) {
        if (tabItem == delegateTabItem) {
            self.view.endEditing(true)
            replaceChildViewController(viewController: delegateBandwidthViewController, containerView: containerView)
        } else if (tabItem == undelegatedTabItem) {
            self.view.endEditing(true)
            replaceChildViewController(viewController: undelegateBandwidthViewController, containerView: containerView)
        } else if (tabItem == allocatedTabItem) {
            self.view.endEditing(true)
            replaceChildViewController(viewController: allocatedBandwidthViewController, containerView: containerView)
        }
    }
    
    func selected(delegatedBandwidth: DelegatedBandwidth) {
        tabBar.animate(to: undelegatedTabItem, completion: nil)
        let prepopulatedUndelegatedBandwidthViewController = createUndelegateBandwidthViewController()
        prepopulatedUndelegatedBandwidthViewController.prepopulated = delegatedBandwidth
        replaceChildViewController(viewController: prepopulatedUndelegatedBandwidthViewController, containerView: containerView)
    }
    
    private func createUndelegateBandwidthViewController() -> UndelegateBandwidthViewController {
        let undelegateBandwidthViewController = R.storyboard.main.undelegatedBandwidthViewController()!
        undelegateBandwidthViewController.manageBandwidthBundle = self.manageBandwidthBundle!
        return undelegateBandwidthViewController
    }
}
