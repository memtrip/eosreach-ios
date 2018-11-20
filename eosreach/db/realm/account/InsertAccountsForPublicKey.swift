import Foundation
import RxSwift
import RealmSwift

class InsertAccountsForPublicKey {
    
    func insertAccounts(publicKey: String, accounts: [AccountNameSystemBalance]) -> Single<[AccountEntity]> {
        return Single.create { single in
            
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
            
            do {
                let realm = try Realm()
                let results = realm
                    .objects(AccountEntity.self)
                    .filter("publicKey = %@", publicKey)
                try realm.write {
                    realm.delete(results)
                    realm.add(accountEntities)
                }
                
                single(.success(accountEntities))
            } catch {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
}
