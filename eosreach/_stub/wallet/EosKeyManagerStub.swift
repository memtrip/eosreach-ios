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
            let publicKey = eosPrivateKey.publicKey.base58
            let stubUnencryptedBytes = eosPrivateKey.bytes()
            self.encryptedKeyPairData.put(newKey: publicKey, value: stubUnencryptedBytes)
            single(.success(publicKey))
            return Disposables.create()
        }
    }
    
    override func getPrivateKeys() -> Single<[EOSPrivateKey]> {
        return Single<[EOSPrivateKey]>.create { single in
            single(.success(self.encryptedKeyPairData.getAll().map { pair in
                return EOSPrivateKey(ecKeyPrivateKey: ECPrivateKey(privKeyData: pair.value))
            }))
            return Disposables.create()
        }
    }
    
    override func getPrivateKey(eosPublicKey: String) -> Single<EOSPrivateKey> {
        return Single<EOSPrivateKey>.create { single in
            single(.success(EOSPrivateKey(ecKeyPrivateKey: ECPrivateKey(privKeyData: self.encryptedKeyPairData.getItem(key: eosPublicKey)))))
            return Disposables.create()
        }
    }
}
