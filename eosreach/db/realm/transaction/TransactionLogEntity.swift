import Foundation
import RealmSwift

class TransactionLogEntity: Object {
    @objc dynamic var transactionId = ""
    @objc dynamic var formattedDate = ""
}
