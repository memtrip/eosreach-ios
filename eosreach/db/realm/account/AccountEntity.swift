import Foundation
import RealmSwift

class AccountEntity: Object {
    @objc dynamic var publicKey = ""
    @objc dynamic var accountName = ""
    @objc dynamic var balance: Double = 0.0
    @objc dynamic var symbol = ""
}
