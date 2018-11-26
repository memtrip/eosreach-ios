import Foundation
import UIKit

class KeyPairCell : SimpleTableViewCell<ViewKeyPair> {
    
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var publicKeyLabel: UILabel!
    @IBOutlet weak var publicKeyValue: UITextView!
    @IBOutlet weak var privateKeyLabel: UILabel!
    @IBOutlet weak var privateKeyValue: UITextView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func populate(item: ViewKeyPair) {
        publicKeyLabel.text = R.string.settingsStrings.settings_key_pair_cell_public_key_title()
        privateKeyLabel.text = R.string.settingsStrings.settings_key_pair_cell_private_key_title()
        accountNameLabel.text = item.associatedAccounts.joined(separator:", ")
        publicKeyValue.text = item.eosPrivateKey.publicKey.base58
        privateKeyValue.text = item.eosPrivateKey.base58
    }
}
