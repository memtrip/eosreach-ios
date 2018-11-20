import Foundation
import RxSwift
import RealmSwift

class DeleteTransactionLog {
    
    func remove() -> Completable {
        return Completable.create { completable in
            do {
                let realm = try Realm()
                let results = realm
                    .objects(TransactionLogEntity.self)
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


