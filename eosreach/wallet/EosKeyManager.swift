import Foundation
import EllipticCurveKeyPair
import LocalAuthentication
import RxSwift
import eosswift

protocol EosKeyManager {
    func importPrivateKey(eosPrivateKey: EOSPrivateKey) -> Single<String>
    func getPrivateKey(eosPublicKey: String) -> Single<EOSPrivateKey>
    func publicKeyExists(eosPublicKey: String) -> Bool
    func getAllPublicKeys() -> [String]
    func getPrivateKeys() -> Single<[EOSPrivateKey]>
    func createEosPrivateKey(value: String) -> Single<EOSPrivateKey>
    func createEosPrivateKey() -> Single<EOSPrivateKey>
    func removeKeystoreEntries() -> Completable
}

class EosKeyManagerImpl: EosKeyManager {

    private struct KeyPair {
        static let manager: EllipticCurveKeyPair.Manager = {
            let publicAccessControl = EllipticCurveKeyPair.AccessControl(protection: kSecAttrAccessibleAlwaysThisDeviceOnly, flags: [])
            let privateAccessControl = EllipticCurveKeyPair.AccessControl(protection: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly, flags: [.userPresence, .privateKeyUsage])
            let config = EllipticCurveKeyPair.Config(
                publicLabel: "eosprivatekey.sign.public",
                privateLabel: "eosprivatekey.sign.private",
                operationPrompt: "Decrypted private key",
                publicKeyAccessControl: publicAccessControl,
                privateKeyAccessControl: privateAccessControl,
                token: .secureEnclave)
            return EllipticCurveKeyPair.Manager(config: config)
        }()
    }

    internal let encryptedKeyPairData = EncryptedKeyPairData()

    func importPrivateKey(eosPrivateKey: EOSPrivateKey) -> Single<String> {
        return Single<String>.create { single in
            do {
                let publicKey = eosPrivateKey.publicKey.base58
                let encrypted = try KeyPair.manager.encrypt(eosPrivateKey.bytes(), hash: .sha256)
                self.encryptedKeyPairData.put(newKey: publicKey, value: encrypted)
                single(.success(publicKey))
            } catch {
                single(.error(error))
            }
            return Disposables.create()
        }
    }

    func getPrivateKey(eosPublicKey: String) -> Single<EOSPrivateKey> {
        return Single<EOSPrivateKey>.create { single in
            do {
                single(.success(try self.getEncryptedPrivateKey(eosPublicKey: eosPublicKey)))
            } catch {
                single(.error(error))
            }
            return Disposables.create()
        }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background)).observeOn(MainScheduler.instance)
    }

    private func getEncryptedPrivateKey(eosPublicKey: String) throws -> EOSPrivateKey {
        let encrypted = self.encryptedKeyPairData.getItem(key: eosPublicKey)
        let decrypted = try KeyPair.manager.decrypt(encrypted, hash: .sha256)
        return EOSPrivateKey(ecKeyPrivateKey: ECPrivateKey(privKeyData: decrypted))
    }

    func publicKeyExists(eosPublicKey: String) -> Bool {
        return encryptedKeyPairData.keyExists(key: eosPublicKey)
    }

    func getAllPublicKeys() -> [String] {
        return encryptedKeyPairData.getKeys()
    }

    func getPrivateKeys() -> Single<[EOSPrivateKey]> {
        return Single<[EOSPrivateKey]>.create { single in
            do {
                single(.success(try self.encryptedKeyPairData.getAll().map { pair in
                    return try self.getEncryptedPrivateKey(eosPublicKey: pair.key)
                }))
            } catch {
                single(.error(error))
            }
            return Disposables.create()
        }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background)).observeOn(MainScheduler.instance)
    }

    func createEosPrivateKey(value: String) -> Single<EOSPrivateKey> {
        return Single<EOSPrivateKey>.create { single in
            do {
                single(.success(try EOSPrivateKey(base58: value)))
            } catch {
                single(.error(error))
            }
            return Disposables.create()
        }
    }

    func createEosPrivateKey() -> Single<EOSPrivateKey> {
        return Single<EOSPrivateKey>.create { single in
            do {
                single(.success(try EOSPrivateKey()))
            } catch {
                single(.error(error))
            }
            return Disposables.create()
        }
    }

    func removeKeystoreEntries() -> Completable {
        return Completable.create { completable in
            self.encryptedKeyPairData.purge()
            completable(.completed)
            return Disposables.create()
        }
    }
}

class EosKeyManagerFactory {

    static func create() -> EosKeyManager {
        switch TargetSwitch.api() {
        case .stub:
            return EosKeyManagerStub()
        case .dev:
            return EosKeyManagerStub()
        case .prod:
            return EosKeyManagerImpl()
        }
    }
}
