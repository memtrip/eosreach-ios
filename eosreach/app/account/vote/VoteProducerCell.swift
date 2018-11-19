import Foundation
import UIKit

class VoteProducerCell : SimpleTableViewCell<String> {
    
    @IBOutlet weak var producerNameLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func populate(item: String) {
        producerNameLabel.text = item
    }
}
