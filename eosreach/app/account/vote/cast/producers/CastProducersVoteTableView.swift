import Foundation
import UIKit

class CastProducersVoteTableView : SimpleTableView<String, CastProducersVoteCell>, UITextFieldDelegate, CastProducersRemoveDelegate {

    override func cellNib() -> UINib {
        return UINib(resource: R.nib.castProducersVoteCell)
    }
    
    override func cellId() -> String {
        return "CastProducersVoteCell"
    }
    
    override func createCell(tableView: UITableView, indexPath: IndexPath) -> CastProducersVoteCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId(), for: indexPath) as! CastProducersVoteCell
        cell.textField.delegate = self
        cell.textField.tag = indexPath.item
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    func removePressed(indexPath: IndexPath) {
        print("remove at: \(indexPath.row)")
    }
}
