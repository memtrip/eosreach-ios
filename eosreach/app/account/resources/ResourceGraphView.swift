import Foundation
import UIKit

class ResourceGraphView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var usageLabel: UILabel!
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    private func initView() {
        Bundle.main.loadNibNamed(R.nib.resourceGraphView.name, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func populate(
        titleLabelValue: String,
        usageLabelValue: String,
        percentage: Float,
        graphColor: UIColor
    ) {
        titleLabel.text = titleLabelValue
        usageLabel.text = usageLabelValue
        progressView.setProgress(percentage, animated: true)
        progressView.progressTintColor = graphColor
    }
}
