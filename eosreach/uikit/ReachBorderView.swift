import Foundation
import UIKit

class ReachBorderView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let color = R.color.colorBorderTransparent()!
        
        layer.borderWidth = 1.0
        layer.borderColor = color.cgColor
        layer.cornerRadius = 3.0
        clipsToBounds = true
    }
}
