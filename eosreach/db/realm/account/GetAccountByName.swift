import Foundation
import RxSwift
import RealmSwift

class GetAccountByName {
    
    func select(accountName: String) -> Single<AccountEntity> {
        return Single.create { single in
            do {
                let realm = try Realm()
                let results = realm
                    .objects(AccountEntity.self)
                    .filter("accountName = %@", accountName)
                single(.success(results[0]))
            } catch {
                single(.error(error))
            }
            return Disposables.create()
        }
    }
}
