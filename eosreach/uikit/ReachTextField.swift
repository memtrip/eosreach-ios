import Foundation
import Material

class ReachTextField : TextField {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tintColor = R.color.colorAccent()
        textColor = R.color.typographyColorPrimary()
        placeholderNormalColor = R.color.typographyColorPlaceholder()!
        dividerNormalColor = R.color.colorAccent()!
        placeholderActiveColor = R.color.colorAccent()!
        dividerActiveColor = R.color.colorAccent()!
    }
}
