import Foundation
import RxSwift
import RealmSwift

class GetAccounts {
    
    func select() -> Single<[AccountEntity]> {
        return Single.create { single in
            do {
                let realm = try Realm()
                try realm.write {
                    let results = realm
                        .objects(AccountEntity.self)
                    single(.success(Array(results)))
                }
            } catch {
                single(.error(error))
            }
            return Disposables.create()
        }
    }
}
