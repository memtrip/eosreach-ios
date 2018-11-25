import Foundation
import UIKit

class CastProducersVoteTableView : SimpleTableView<String, CastProducersVoteCell>, UITextFieldDelegate, CastProducersRemoveDelegate {

    private let usernameFilter = UsernameFilter()
    
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
    
    func removePressed(indexPath: IndexPath) {
        data.remove(at: indexPath.row)
        self.reloadData()
    }
    
    func addProducer(producer: String) {
        let rowCount = numberOfRows(inSection: 0)
        if (rowCount < 30) {
            self.populate(data: [producer])
            print(numberOfRows(inSection: 0))
        }
    }
    
    //
    // MARK :- UITextFieldDelegate
    //
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return usernameFilter.check(string: string, textField: textField)
    }
}
