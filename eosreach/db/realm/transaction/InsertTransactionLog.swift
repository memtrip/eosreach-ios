import Foundation
import RxSwift
import RealmSwift

class InsertTransactionLog {
    
    func insert(transactionLogEntities: [TransactionLogEntity]) -> Completable {
        return Completable.create { completable in
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(transactionLogEntities)
                    completable(.completed)
                }
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
}
