import Foundation
import UIKit

class ResourceGraphView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var usageLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func populate(
        titleLabelValue: String,
        usageLabelValue: String,
        percentage: Float,
        graphColor: UIColor
    ) {
        titleLabel.text = titleLabelValue
        usageLabel.text = usageLabelValue
        progressView.progress = percentage
        progressView.progressTintColor = graphColor
    }
}
