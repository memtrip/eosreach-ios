import Foundation
import UIKit

class AccountCardTableView : SimpleTableView<AccountCardModel, AccountCardCell> {
    
    override func cellNib() -> UINib {
        return UINib(resource: R.nib.accountCardCell)
    }
    
    override func cellId() -> String {
        return "AccountCardCell"
    }
    
    override func createCell(tableView: UITableView, indexPath: IndexPath) -> AccountCardCell {
        return tableView.dequeueReusableCell(withIdentifier: self.cellId(), for: indexPath) as! AccountCardCell
    }
}
