import Foundation

class RsaEncryptionVerified {

    private let key = "RSA_ENCRYPTION_VERIFIED"
    private let defaults = UserDefaults.standard

    func put(value: Bool) {
        defaults.set(value, forKey: key)
    }

    func get() -> Bool {
        return defaults.bool(forKey: key)
    }
}
