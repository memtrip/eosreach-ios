import Foundation
import UIKit

class AllocatedBandwidthCell : SimpleTableViewCell<DelegatedBandwidth> {
    
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var cpuLabel: UILabel!
    @IBOutlet weak var netLabel: UILabel!
    @IBOutlet weak var cpuValueLabel: UILabel!
    @IBOutlet weak var netValueLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func populate(item: DelegatedBandwidth) {
        accountNameLabel.text = item.accountName
        cpuLabel.text = R.string.bandwidthStrings.allocated_bandwidth_cell_cpu_label()
        cpuValueLabel.text = item.cpuWeight
        netLabel.text = R.string.bandwidthStrings.allocated_bandwidth_cell_net_label()
        netValueLabel.text = item.netWeight
    }
}
