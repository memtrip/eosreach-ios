import Foundation
import RxSwift
import RealmSwift

class GetTransactionHistory {
 
    func select() -> Single<[TransactionHistoryModel]> {
        return Single.create { single in
            do {
                let realm = try Realm()
                let results = realm
                    .objects(TransactionLogEntity.self)
                single(.success(Array(results).map { result in
                    TransactionHistoryModel(
                        transactionId: result.transactionId,
                        date: result.formattedDate)
                }))
            } catch {
                single(.error(error))
            }
            return Disposables.create()
        }
    }
}
