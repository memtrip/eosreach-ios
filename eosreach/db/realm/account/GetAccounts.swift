import Foundation
import RxSwift
import RealmSwift

class GetAccounts {
    
    func select() -> Single<[AccountModel]> {
        return Single.create { single in
            do {
                let realm = try Realm()
                let results = realm
                    .objects(AccountEntity.self)
                single(.success(Array(results.map { accountEntity in
                    return AccountModel(
                        accountName: accountEntity.accountName,
                        balance: BalanceFormatter.create(
                            amount: accountEntity.balance,
                            symbol: accountEntity.symbol)
                    )
                })))
            } catch {
                single(.error(error))
            }
            return Disposables.create()
        }
    }
}
