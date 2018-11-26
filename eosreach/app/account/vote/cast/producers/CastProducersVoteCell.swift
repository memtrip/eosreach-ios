import Foundation
import UIKit

class CastProducersVoteCell : SimpleTableViewCell<String> {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var removeButton: UIButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func populate(item: String) {
        textField.text = item
        removeButton.addTarget(self, action: #selector(removeTap), for: .touchUpInside)
    }
    
    @objc private func removeTap() {
        if let extraTapDelegate = extraTapDelegate {
            extraTapDelegate.extraTap(indexPath: indexPath!)
        }
    }
}
