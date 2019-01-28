import Foundation
import RxSwift
import RealmSwift

class DropDb {
    
    func drop() -> Completable {
        return Completable.create { completable in
            do {
                try self.cleanUp()
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
    
    func cleanUp() throws {
        UserDefaults.standard.removePersistentDomain(
            forName: Bundle.main.bundleIdentifier!)
        
        let realm = try Realm()
        try realm.write {
            realm.deleteAll()
        }
    }
}
