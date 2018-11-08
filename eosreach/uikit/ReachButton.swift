import UIKit
import Material

class ReachButton: FlatButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        let color = R.color.colorButtonSecondary()!

        layer.borderWidth = 1.0
        layer.borderColor = color.cgColor
        layer.cornerRadius = 3.0
        clipsToBounds = true
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        setTitleColor(R.color.typographyColorPrimary(), for: .normal)
    }
}

class ReachPrimaryButton : ReachButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setBackgroundImage(UIImage(color: R.color.colorAccent()!), for: .normal)
        layer.borderWidth = 0
    }
}

class ReachNavigationButton : ReachButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.borderWidth = 0
        layer.cornerRadius = 0
        contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}
