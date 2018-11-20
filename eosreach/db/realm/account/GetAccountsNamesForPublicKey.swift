import Foundation
import RxSwift
import RealmSwift

class GetAccountsNamesForPublicKey {

    func names(publicKey: String) -> Single<[String]> {
        return Single.create { single in
            do {
                let realm = try Realm()
                let results = Array(realm
                    .objects(AccountEntity.self)).map { entity in
                    return entity.accountName
                }
                single(.success(Array(results)))
            } catch {
                single(.error(error))
            }
            return Disposables.create()
        }
    }
}
