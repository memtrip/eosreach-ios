import Foundation
import RxSwift
import RealmSwift

class GetBalances {
    
    func select(accountName: String) -> Single<[BalanceEntity]> {
        return Single.create { single in
            do {
                let realm = try Realm()
                let results = realm
                    .objects(BalanceEntity.self)
                    .filter("accountName = %@", accountName)
                single(.success(Array(results)))
            } catch {
                single(.error(error))
            }
            return Disposables.create()
        }
    }
}
