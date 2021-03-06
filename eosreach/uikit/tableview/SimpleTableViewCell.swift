import Foundation
import UIKit

class SimpleTableViewCell<T> : UITableViewCell {
    
    var extraTapDelegate: ExtraTapDelegate?
    var indexPath: IndexPath?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    func initView() {
        contentView.backgroundColor = R.color.colorWindowBackground()
    }
    
    func populate(item: T) {
        fatalError("populate must be implemented")
    }
}
