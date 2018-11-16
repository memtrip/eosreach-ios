import Foundation
import RxSwift
import RealmSwift

class InsertAccountsForPublicKey {
    
    func replace(publicKey: String, accounts: [AccountNameSystemBalance]) -> Single<[AccountEntity]> {

        let accountEntities = accounts.map { accountNameSystemBalance -> AccountEntity in
            let accountEntity = AccountEntity()
            accountEntity.publicKey = publicKey
            accountEntity.accountName = accountNameSystemBalance.accountName
            if (accountNameSystemBalance.systemBalance != nil) {
                let balance = BalanceFormatter.deserialize(balance: accountNameSystemBalance.systemBalance!)
                accountEntity.balance = balance.amount
                accountEntity.symbol = balance.symbol
            }
            return accountEntity
        }
        
        return deleteByPublicKey(publicKey: publicKey)
            .andThen(insertAccounts(accountEntities: accountEntities))
            .andThen(Single.just(accountEntities))
    }
    
    private func deleteByPublicKey(publicKey: String) -> Completable {
        return Completable.create { completable in
            do {
                let realm = try Realm()
                try realm.write {
                    let results = realm
                        .objects(AccountEntity.self)
                        .filter("publicKey = %@", publicKey)
                    realm.delete(results)
                    completable(.completed)
                }
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
    
    private func insertAccounts(accountEntities: [AccountEntity]) -> Completable {
        return Completable.create { completable in
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(accountEntities)
                    completable(.completed)
                }
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
}
