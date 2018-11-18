import UIKit

class ReachActivityIndicator : UIActivityIndicatorView {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        color = R.color.colorAccent()
        hidesWhenStopped = true
    }
}

extension ReachActivityIndicator {

    func start() {
        isHidden = false
        startAnimating()
    }

    func stop() {
        isHidden = true
        stopAnimating()
    }
}
