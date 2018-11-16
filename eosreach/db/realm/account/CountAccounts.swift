import Foundation
import RealmSwift
import RxSwift

class CountAccounts {
    
    func count() -> Single<Int> {
        return Single<Int>.create { single in
            if let realm = try? Realm() {
                let accounts = realm.objects(AccountEntity.self)
                single(.success(accounts.count))
            } else {
                single(.error(ConnectionError()))
            }
            
            return Disposables.create()
        }
    }
}
