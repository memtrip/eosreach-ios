import Foundation
import Material

class ReachAccountCard: FlatButton {
    
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let color = R.color.colorButtonSecondary()!
        
        layer.borderWidth = 1.0
        layer.borderColor = color.cgColor
        layer.cornerRadius = 3.0
        clipsToBounds = true
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        setTitleColor(R.color.typographyColorPrimary(), for: .normal)
    }
    
    func populate(model: Model) {
        accountNameLabel.text = model.accountName
        balanceLabel.text = BalanceFormatter.formatEosBalance(balance: model.balance)
    }
    
    struct Model {
        let accountName: String
        let balance: Balance
    }
}
