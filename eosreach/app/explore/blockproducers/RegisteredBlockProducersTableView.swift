import Foundation
import UIKit

class RegisteredBlockProducersTableView : SimpleTableView<RegisteredBlockProducer, RegisteredBlockProducersCell> {

    override func cellNib() -> UINib {
        return UINib(resource: R.nib.registeredBlockProducersCell)
    }

    override func cellId() -> String {
        return "RegisteredBlockProducersTableView"
    }

    override func createCell(tableView: UITableView, indexPath: IndexPath) -> RegisteredBlockProducersCell {
        return tableView.dequeueReusableCell(withIdentifier: self.cellId(), for: indexPath) as! RegisteredBlockProducersCell
    }
}
