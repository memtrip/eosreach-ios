import Foundation
import UIKit

class ProxyVoterListCell : SimpleTableViewCell<ProxyVoterDetails> {
   
    @IBOutlet weak var proxyImageView: UIImageView!
    @IBOutlet weak var proxyName: UILabel!
    @IBOutlet weak var proxySlogan: UILabel!
    @IBOutlet weak var proxyInformation: UIImageView!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func populate(item: ProxyVoterDetails) {
        proxyName.text = item.name
        proxySlogan.text = item.slogan
        // TODO: image view
    }
}
