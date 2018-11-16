import Foundation
import RealmSwift

class BalanceEntity: Object {
    @objc dynamic var accountName = ""
    @objc dynamic var contractName = ""
    @objc dynamic var symbol = ""
}
