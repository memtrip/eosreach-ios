import Foundation
import RxSwift
import RealmSwift

class DeleteAccounts {
    
    func remove() -> Completable {
        return Completable.create { completable in
            do {
                let realm = try Realm()
                let results = realm
                    .objects(AccountEntity.self)
                
                try realm.write {
                    realm.delete(results)
                }
                
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
}
