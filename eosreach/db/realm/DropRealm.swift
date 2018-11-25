import Foundation
import RxSwift
import RealmSwift

class DropRealm {
    
    func drop() -> Completable {
        return Completable.create { completable in
            do {
                let realm = try Realm()
                try realm.write {
                    realm.deleteAll()
                }
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
}
