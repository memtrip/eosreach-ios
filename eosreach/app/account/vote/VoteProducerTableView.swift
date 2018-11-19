import Foundation
import UIKit

class VoteProducerTableView : SimpleTableView<String, VoteProducerCell> {
    
    override func cellNib() -> UINib {
        return UINib(resource: R.nib.voteProducerCell)
    }
    
    override func cellId() -> String {
        return "VoteProducerCell"
    }
    
    override func createCell(tableView: UITableView, indexPath: IndexPath) -> VoteProducerCell {
        return tableView.dequeueReusableCell(withIdentifier: self.cellId(), for: indexPath) as! VoteProducerCell
    }
}
