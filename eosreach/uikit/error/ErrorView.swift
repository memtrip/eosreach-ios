import Foundation
import UIKit
import RxCocoa

class ErrorView : UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var retryButton: ReachPrimaryButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewInit()
    }

    private func viewInit() {
        Bundle.main.loadNibNamed(R.nib.errorView.name, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        titleLabel.text = R.string.appStrings.app_error_view_title()
        retryButton.setTitle(R.string.appStrings.app_error_view_cta(), for: .normal)

        titleLabel.textColor = R.color.typographyColorPrimary()
        bodyLabel.textColor = R.color.typographyColorPrimary()
        gone() // start hidden
    }

    func populate(body: String) {
        bodyLabel.text = body
    }
    
    func populate(title: String, body: String) {
        titleLabel.text = title
        bodyLabel.text = body
    }

    func retryClick() -> RxCocoa.ControlEvent<Void> {
        return retryButton.rx.tap
    }
}
