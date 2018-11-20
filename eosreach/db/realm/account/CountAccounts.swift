import Foundation
import RealmSwift
import RxSwift

class CountAccounts {
    
    func count() -> Single<Int> {
        return Single<Int>.create { single in
            do {
                let realm = try Realm()
                let accounts = realm.objects(AccountEntity.self)
                single(.success(accounts.count))
            } catch {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
}
