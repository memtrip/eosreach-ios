import Foundation
import UIKit

class TransactionHistoryCell : SimpleTableViewCell<TransactionHistoryModel> {
    
    @IBOutlet weak var transactionIdLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func populate(item: TransactionHistoryModel) {
        transactionIdLabel.text = item.transactionId
        dateLabel.text = item.date
    }
}
