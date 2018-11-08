import Foundation
import Material

class ReachTabBar : TabBar {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setLineColor(R.color.colorAccent()!, for: .selected)
        backgroundColor = R.color.colorWindowBackground()
        tintColor = R.color.colorAccent()
        dividerColor = UIColor(white: 1, alpha: 0)
    }

    func setup() {
        tabItems.forEach { tabItem in
            tabItem.titleColor = R.color.typographyColorPrimary()
        }
    }
}
