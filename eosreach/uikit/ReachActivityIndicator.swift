import UIKit

class ReachActivityIndicator : UIActivityIndicatorView {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        color = R.color.colorAccent()
        startAnimating()
    }
}
