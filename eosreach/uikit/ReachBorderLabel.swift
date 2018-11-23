import Foundation
import UIKit

class ReachBorderLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let color = R.color.colorBorderTransparent()!
        
        layer.borderWidth = 1.0
        layer.borderColor = color.cgColor
        layer.cornerRadius = 3.0
        clipsToBounds = true
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + 8 + 8,
                      height: size.height + 8 + 8)
    }
}
