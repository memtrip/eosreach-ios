import Foundation
import UIKit

class CastProducerVoteTableView : SimpleTableView<String, CastProducerVoteCell>, UITextFieldDelegate {
    
    override func cellNib() -> UINib {
        return UINib(resource: R.nib.castProducerVoteCell)
    }
    
    override func cellId() -> String {
        return "CastProducerVoteCell"
    }
    
    override func createCell(tableView: UITableView, indexPath: IndexPath) -> CastProducerVoteCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId(), for: indexPath) as! CastProducerVoteCell
        cell.textField.delegate = self
        cell.textField.tag = indexPath.item
        return cell
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
    }
}
