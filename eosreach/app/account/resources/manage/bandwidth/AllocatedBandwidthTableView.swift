import Foundation
import UIKit

class AllocatedBandwidthTableView : SimpleTableView<DelegatedBandwidth, AllocatedBandwidthCell> {
    
    override func cellNib() -> UINib {
        return UINib(resource: R.nib.allocatedBandwidthCell)
    }
    
    override func cellId() -> String {
        return "AllocationBandwidthCell"
    }
    
    override func createCell(tableView: UITableView, indexPath: IndexPath) -> AllocatedBandwidthCell {
        return tableView.dequeueReusableCell(withIdentifier: self.cellId(), for: indexPath) as! AllocatedBandwidthCell
    }
}
