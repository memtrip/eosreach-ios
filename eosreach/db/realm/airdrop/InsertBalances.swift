import Foundation
import RxSwift
import RealmSwift

class InsertBalances {
    
    func replace(accountName: String, contractAccountBalances: [ContractAccountBalance]) -> Single<[BalanceEntity]> {
        
        let balanceEntities = contractAccountBalances.map { contractAccountBalance -> BalanceEntity in
            let balanceEntity = BalanceEntity()
            balanceEntity.accountName = contractAccountBalance.accountName
            balanceEntity.contractName = contractAccountBalance.contractName
            balanceEntity.symbol = contractAccountBalance.balance.symbol
            return balanceEntity
        }
        
        return deleteByAccountName(accountName: accountName)
            .andThen(insertBalances(balanceEntities: balanceEntities))
            .andThen(Single.just(balanceEntities))
    }
    
    private func deleteByAccountName(accountName: String) -> Completable {
        return Completable.create { completable in
            do {
                let realm = try Realm()
                try realm.write {
                    let results = realm
                        .objects(BalanceEntity.self)
                        .filter("accountName = %@", accountName)
                    realm.delete(results)
                    completable(.completed)
                }
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
    
    private func insertBalances(balanceEntities: [BalanceEntity]) -> Completable {
        return Completable.create { completable in
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(balanceEntities)
                    completable(.completed)
                }
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
}
