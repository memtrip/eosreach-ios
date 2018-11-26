import Foundation
import UIKit
import Kingfisher

class ProxyVoterListCell : SimpleTableViewCell<ProxyVoterDetails> {
   
    @IBOutlet weak var proxyImageView: UIImageView!
    @IBOutlet weak var proxyName: UILabel!
    @IBOutlet weak var proxySlogan: UILabel!
    @IBOutlet weak var viewProxyButton: UIButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func populate(item: ProxyVoterDetails) {
        proxyName.text = item.name
        proxySlogan.text = item.slogan
        viewProxyButton.addTarget(self, action: #selector(viewProxyTap), for: .touchUpInside)
        
        if let url = URL(string: item.logo256) {
            proxyImageView.kf.setImage(with: url)
            proxyImageView.contentMode = .scaleAspectFit
        }
    }
    
    @objc private func viewProxyTap() {
        if let extraTapDelegate = extraTapDelegate {
            extraTapDelegate.extraTap(indexPath: indexPath!)
        }
    }
}
