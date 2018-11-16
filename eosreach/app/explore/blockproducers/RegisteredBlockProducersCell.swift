import Foundation
import UIKit

class RegisteredBlockProducersCell : SimpleTableViewCell<RegisteredBlockProducer> {
    
    @IBOutlet weak var blockProducerNameLabel: UILabel!
    @IBOutlet weak var totalVotesLabel: UILabel!
    @IBOutlet weak var websiteImage: UIImageView!
    @IBOutlet weak var rowContent: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func populate(item: RegisteredBlockProducer) {
        blockProducerNameLabel.text = item.owner
        totalVotesLabel.text = item.votesInEos
    }
}
