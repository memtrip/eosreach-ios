import Foundation
import UIKit

class KeyPairTableView : SimpleTableView<ViewKeyPair, KeyPairCell> {
    
    override func cellNib() -> UINib {
        return UINib(resource: R.nib.keyPairCell)
    }
    
    override func cellId() -> String {
        return "KeyPairCell"
    }
    
    override func createCell(tableView: UITableView, indexPath: IndexPath) -> KeyPairCell {
        return tableView.dequeueReusableCell(withIdentifier: self.cellId(), for: indexPath) as! KeyPairCell
    }
}
