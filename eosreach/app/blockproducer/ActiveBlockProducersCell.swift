import Foundation
import UIKit

class ActiveBlockProducersCell : SimpleTableViewCell<BlockProducerDetails> {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var blockProducerNameLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var informationView: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func populate(item: BlockProducerDetails) {
        blockProducerNameLabel.text = item.candidateName
        ownerLabel.text = item.owner
    }
}
