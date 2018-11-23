import Foundation
import UIKit

class ActionsCell : SimpleTableViewCell<AccountAction> {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var fiatLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func populate(item: AccountAction) {
        accountNameLabel.text = item.transferInteractingAccountName
        balanceLabel.text = BalanceFormatter.formatEosBalance(balance: item.quantity)
        dateLabel.text = item.formattedDate
        fiatLabel.text = item.currencyPairValue
        
        if (item.transferIncoming) {
            // incoming icon
        } else {
            // outgoing icon
        }
    }
}
