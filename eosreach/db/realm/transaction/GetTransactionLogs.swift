import Foundation
import RxSwift
import RealmSwift

class GetTransactionLogs {
 
    func select() -> Single<[TransactionLogEntity]> {
        return Single.create { single in
            do {
                let realm = try Realm()
                let results = realm
                    .objects(TransactionLogEntity.self)
                single(.success(Array(results)))
            } catch {
                single(.error(error))
            }
            return Disposables.create()
        }
    }
}
