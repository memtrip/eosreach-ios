import Foundation
import UIKit

class SimpleTableViewCell<T> : UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    private func initView() {
        contentView.backgroundColor = R.color.colorWindowBackground()
    }
    
    func populate(item: T) {
        fatalError("populate must be implemented")
    }
}
