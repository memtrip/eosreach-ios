import Foundation
import UIKit

class BalanceTableView : SimpleTableView<ContractAccountBalance, BalanceCell> {
    
    override func cellNib() -> UINib {
        return UINib(resource: R.nib.balanceCell)
    }
    
    override func cellId() -> String {
        return "BalanceCell"
    }
    
    override func createCell(tableView: UITableView, indexPath: IndexPath) -> BalanceCell {
        return tableView.dequeueReusableCell(withIdentifier: self.cellId(), for: indexPath) as! BalanceCell
    }
}
