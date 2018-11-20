import UIKit
import RxSwift
import RxCocoa
import Material

class ExploreViewController: UIViewController, TabBarDelegate {

    @IBOutlet weak var toolbar: ReachToolbar!
    @IBOutlet weak var tabBar: ReachTabBar!
    @IBOutlet weak var containerView: UIView!

    let searchTabItem = TabItem()
    let blockProducersTabItem = TabItem()

    private lazy var searchViewController: SearchViewController = {
        return R.storyboard.main.searchViewController()!
    }()

    private lazy var registeredBlockProducersViewController: RegisteredBlockProducersViewController = {
        return R.storyboard.main.registeredBlockProducersViewController()!
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        toolbar.title = R.string.exploreStrings.explore_title()
        setToolbar(toolbar: toolbar)

        searchTabItem.title = R.string.exploreStrings.explore_tab_search()
        blockProducersTabItem.title = R.string.exploreStrings.explore_tab_blockproducers()
        tabBar.tabItems = [searchTabItem,blockProducersTabItem]
        tabBar.setup()
        tabBar.delegate = self

        view.backgroundColor = Res.color.colorWindowBackground()
        replaceChildViewController(viewController: searchViewController)
    }

    private func replaceChildViewController(viewController: UIViewController) {
        addChild(viewController)
        containerView.addSubview(viewController.view)

        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }

    @objc func tabBar(tabBar: TabBar, willSelect tabItem: TabItem) {
        if (tabItem == searchTabItem) {
            self.view.endEditing(true)
            replaceChildViewController(viewController: searchViewController)
        } else if (tabItem == blockProducersTabItem) {
            self.view.endEditing(true)
            replaceChildViewController(viewController: registeredBlockProducersViewController)
        }
    }
}
