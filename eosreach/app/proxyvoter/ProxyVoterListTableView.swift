import Foundation
import UIKit

class ProxyVoterListTableView : SimpleTableView<ProxyVoterDetails, ProxyVoterListCell> {
        
    override func cellNib() -> UINib {
        return UINib(resource: R.nib.proxyVoterListCell)
    }
    
    override func cellId() -> String {
        return "ProxyVoterListCell"
    }
    
    override func createCell(tableView: UITableView, indexPath: IndexPath) -> ProxyVoterListCell {
        return tableView.dequeueReusableCell(withIdentifier: self.cellId(), for: indexPath) as! ProxyVoterListCell
    }
}
