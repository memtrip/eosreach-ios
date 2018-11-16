import Foundation
import UIKit

class RegisteredBlockProducersCell : SimpleTableViewCell<RegisteredBlockProducer> {
    
    @IBOutlet weak var blockProducerNameLabel: UILabel!
    @IBOutlet weak var totalVotesLabel: UILabel!
    @IBOutlet weak var websiteImage: UIImageView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = R.color.colorWindowBackground()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func populate(item: RegisteredBlockProducer) {
        blockProducerNameLabel.textColor = R.color.typographyColorSecondary()
        totalVotesLabel.textColor = R.color.typographyColorSecondary()
        blockProducerNameLabel.text = item.owner
        totalVotesLabel.text = item.votesInEos
    }
}
