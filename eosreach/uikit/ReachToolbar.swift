import Foundation
import Material

class ReachToolbar : Toolbar {

    let backMenuButton: IconButton

    required init?(coder aDecoder: NSCoder) {
        backMenuButton = IconButton(image: Icon.cm.arrowBack, tintColor: .white)

        super.init(coder: aDecoder)

        backgroundColor = R.color.colorWindowBackground()
        titleLabel.textColor = R.color.typographyColorPrimary()

        leftViews = [backMenuButton]
    }

    func addRightItem(iconButton: IconButton) {
        rightViews.append(iconButton)
    }
}
