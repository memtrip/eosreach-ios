import Foundation
import RxSwift
import RealmSwift

class GetBalances {
    
    func select() -> Single<[BalanceEntity]> {
        return Single.create { single in
            do {
                let realm = try Realm()
                try realm.write {
                    let results = realm
                        .objects(BalanceEntity.self)
                    single(.success(Array(results)))
                }
            } catch {
                single(.error(error))
            }
            return Disposables.create()
        }
    }
}
