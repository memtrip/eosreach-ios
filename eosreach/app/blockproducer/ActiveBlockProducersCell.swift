import Foundation
import UIKit
import Kingfisher

class ActiveBlockProducersCell : SimpleTableViewCell<BlockProducerDetails> {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var blockProducerNameLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var viewBlockProducer: UIButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func populate(item: BlockProducerDetails) {
        blockProducerNameLabel.text = item.candidateName
        ownerLabel.text = item.owner
        viewBlockProducer.addTarget(self, action: #selector(viewBlockProducerButtonTap), for: .touchUpInside)
        
        if let logo256 = item.logo256 {
            if let url = URL(string: logo256) {
                logoImageView.kf.setImage(with: url)
                logoImageView.contentMode = .scaleAspectFit
            }
        }
    }
    
    @objc private func viewBlockProducerButtonTap() {
        if let extraTapDelegate = extraTapDelegate {
            extraTapDelegate.extraTap(indexPath: indexPath!)
        }
    }
}
