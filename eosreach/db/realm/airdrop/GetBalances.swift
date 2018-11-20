import Foundation
import RxSwift
import RealmSwift

class GetBalances {
    
    func select(accountName: String) -> Single<[BalanceModel]> {
        return Single.create { single in
            do {
                let realm = try Realm()
                let results = realm
                    .objects(BalanceEntity.self)
                    .filter("accountName = %@", accountName)
                single(.success(results.map { entity in
                    return BalanceModel(
                        accountName: entity.accountName,
                        contractName: entity.contractName,
                        symbol: entity.symbol
                    )
                }))
            } catch {
                single(.error(error))
            }
            return Disposables.create()
        }
    }
}
