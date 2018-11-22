import Foundation
import UIKit

class ReachSwitch : UISwitch {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tintColor = R.color.colorAccent()
        onTintColor = R.color.colorAccent()
    }
}
