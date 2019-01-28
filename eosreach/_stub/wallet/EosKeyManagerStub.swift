import Foundation
import eosswift
import RxSwift

//
// An EosKeyManager Stub used for ui testing, the SecureElement encryption
// has been disabled to remove the platform dependency.
//
class EosKeyManagerStub : EosKeyManagerImpl {
    
    override func importPrivateKey(eosPrivateKey: EOSPrivateKey) -> Single<String> {
        return Single<String>.create { single in
            do {
                let publicKey = eosPrivateKey.publicKey.base58
                let stubUnencryptedBytes = eosPrivateKey.bytes()
                self.encryptedKeyPairData.put(newKey: publicKey, value: stubUnencryptedBytes)
                single(.success(publicKey))
            } catch {
                single(.error(error))
            }
            return Disposables.create()
        }
    }
    
    override func getPrivateKeys() -> Single<[EOSPrivateKey]> {
        return Single<[EOSPrivateKey]>.create { single in
            do {
                single(.success(try self.encryptedKeyPairData.getAll().map { pair in
                    return EOSPrivateKey(ecKeyPrivateKey: ECPrivateKey(privKeyData: pair.value))
                }))
            } catch {
                single(.error(error))
            }
            return Disposables.create()
        }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background)).observeOn(MainScheduler.instance)
    }
}
