import Foundation
import UIKit
import Kingfisher

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
        
        if let url = URL(string: item.logo256) {
            proxyImageView.kf.setImage(with: url)
            proxyImageView.contentMode = .scaleAspectFit
        }
    }
}
