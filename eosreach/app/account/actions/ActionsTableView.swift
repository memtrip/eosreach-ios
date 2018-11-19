import Foundation
import UIKit

class ActionsTableView : SimpleTableView<AccountAction, ActionsCell> {
    
    override func cellNib() -> UINib {
        return UINib(resource: R.nib.actionsCell)
    }
    
    override func cellId() -> String {
        return "ActionsCell"
    }
    
    override func createCell(tableView: UITableView, indexPath: IndexPath) -> ActionsCell {
        return tableView.dequeueReusableCell(withIdentifier: self.cellId(), for: indexPath) as! ActionsCell
    }
}
