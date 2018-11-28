import Foundation
import UIKit

class TransactionHistoryTableView : SimpleTableView<TransactionHistoryModel, TransactionHistoryCell> {
    
    override func cellNib() -> UINib {
        return UINib(resource: R.nib.transactionHistoryCell)
    }
    
    override func cellId() -> String {
        return "TransactionHistoryCell"
    }
    
    override func createCell(tableView: UITableView, indexPath: IndexPath) -> TransactionHistoryCell {
        return tableView.dequeueReusableCell(withIdentifier: self.cellId(), for: indexPath) as! TransactionHistoryCell
    }
}
