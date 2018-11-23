import Foundation
import UIKit

class ReachNetCpuView : UIView {
    
    @IBOutlet weak var cpuLabel: UILabel!
    @IBOutlet weak var netLabel: UILabel!
    @IBOutlet weak var cpuValueLabel: UILabel!
    @IBOutlet weak var netValueLabel: UILabel!
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewInit()
    }
    
    private func viewInit() {
        Bundle.main.loadNibNamed(R.nib.reachNetCpuView.name, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        cpuLabel.text = R.string.appStrings.app_uitkit_cpu_label()
        netLabel.text = R.string.appStrings.app_uitkit_net_label()
    }
}
