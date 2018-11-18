import Foundation
import UIKit

class BalanceCell : SimpleTableViewCell<ContractAccountBalance> {

    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func populate(item: ContractAccountBalance) {
        symbol.text = item.balance.symbol
        amount.text = BalanceFormatter.formatBalanceDigits(amount: item.balance.amount)
    }
}
