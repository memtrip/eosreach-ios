import Foundation
import RxSwift
import RealmSwift

class InsertBalances {
    
    func replace(accountName: String, contractAccountBalances: [ContractAccountBalance]) -> Single<[BalanceEntity]> {
        return Single.create { single in
            
            let balanceEntities = contractAccountBalances.map { contractAccountBalance -> BalanceEntity in
                let balanceEntity = BalanceEntity()
                balanceEntity.accountName = contractAccountBalance.accountName
                balanceEntity.contractName = contractAccountBalance.contractName
                balanceEntity.symbol = contractAccountBalance.balance.symbol
                return balanceEntity
            }
            
            do {
                let realm = try Realm()
                let results = realm
                    .objects(BalanceEntity.self)
                    .filter("accountName = %@", accountName)
                
                try realm.write {
                    realm.delete(results)
                    realm.add(balanceEntities)
                }
                
                single(.success(balanceEntities))
            } catch {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
}
