import Foundation
import RxSwift
import RealmSwift

class InsertTransactionLog {
    
    func insert(transactionId: String) -> Single<String> {
        let transactionLogEntity = TransactionLogEntity()
        transactionLogEntity.transactionId = transactionId
        transactionLogEntity.formattedDate = Date().fullDateTime()
        return self.insertEntity(transactionEntity: transactionLogEntity)
    }
    
    private func insertEntity(transactionEntity: TransactionLogEntity) -> Single<String> {
        return Single.create { single in
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(transactionEntity)
                }
                single(.success(transactionEntity.transactionId))
            } catch {
                single(.error(error))
            }
            return Disposables.create()
        }
    }
}
