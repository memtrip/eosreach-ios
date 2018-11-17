import Foundation
import UIKit

class AccountCardCell : SimpleTableViewCell<AccountCardModel> {

    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var accountBalanceLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func populate(item: AccountCardModel) {
        accountNameLabel.text = item.accountName
        accountBalanceLabel.text = BalanceFormatter.formatEosBalance(balance: item.balance)
    }
}
