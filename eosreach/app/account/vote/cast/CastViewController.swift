import UIKit
import RxSwift
import RxCocoa
import Material

class CastViewController: UIViewController, TabBarDelegate {
    
    @IBOutlet weak var toolBar: ReachToolbar!
    @IBOutlet weak var tabBar: ReachTabBar!
    @IBOutlet weak var containerView: UIView!
    
    var castBundle: CastBundle?
    
    let producersTabItem = TabItem()
    let proxyTabItem = TabItem()
    
    private lazy var producersViewController: CastProducersVoteViewController = {
        return R.storyboard.main.castProducersVoteViewController()!
    }()
    
    private lazy var proxyViewController: CastProxyVoteViewController = {
        return R.storyboard.main.castProxyVoteViewController()!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolBar.title = R.string.voteStrings.cast_title()
        setToolbar(toolbar: toolBar)
        
        producersTabItem.title = R.string.voteStrings.cast_producers_vote_tab()
        proxyTabItem.title = R.string.voteStrings.cast_proxy_vote_tab()
        tabBar.tabItems = [producersTabItem,proxyTabItem]
        tabBar.setup()
        tabBar.delegate = self
        
        view.backgroundColor = Res.color.colorWindowBackground()
        
        producersViewController.accountName = castBundle!.accountName
        proxyViewController.accountName = castBundle!.accountName
        
        switch castBundle!.castTab {
        case .producers:
            replaceChildViewController(viewController: producersViewController, containerView: containerView)
        case .proxy:
            tabBar.select(at: 1) // select proxy tab
            replaceChildViewController(viewController: proxyViewController, containerView: containerView)
        }
    }
    
    @objc func tabBar(tabBar: TabBar, willSelect tabItem: TabItem) {
        if (tabItem == producersTabItem) {
            self.view.endEditing(true)
            replaceChildViewController(viewController: producersViewController, containerView: containerView)
        } else if (tabItem == proxyTabItem) {
            self.view.endEditing(true)
            replaceChildViewController(viewController: proxyViewController, containerView: containerView)
        }
    }
}
