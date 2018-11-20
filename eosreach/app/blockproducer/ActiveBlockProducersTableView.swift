import Foundation
import UIKit

class ActiveBlockProducersTableView : SimpleTableView<BlockProducerDetails, ActiveBlockProducersCell> {
    
    override func cellNib() -> UINib {
        return UINib(resource: R.nib.activeBlockProducerCell)
    }
    
    override func cellId() -> String {
        return "ActiveBlockProducerCell"
    }
    
    override func createCell(tableView: UITableView, indexPath: IndexPath) -> ActiveBlockProducersCell {
        return tableView.dequeueReusableCell(withIdentifier: self.cellId(), for: indexPath) as! ActiveBlockProducersCell
    }
}
