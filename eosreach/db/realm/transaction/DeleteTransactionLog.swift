import Foundation
import RxSwift
import RealmSwift

class DeleteTransactionLog {
    
    func remove() -> Completable {
        return Completable.create { completable in
            do {
                let realm = try Realm()
                try realm.write {
                    let results = realm
                        .objects(TransactionLogEntity.self)
                    realm.delete(results)
                    completable(.completed)
                }
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
}


