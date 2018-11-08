import Foundation

class EncryptedKeyPairData {

    private let key = "ENCRYPTED_KEY_PAIR_DATA"
    private let defaults = UserDefaults.standard

    func put(newKey: String, value: Data) {
        if var current = defaults.dictionary(forKey: key) {
            current[newKey] = value
            defaults.set(current, forKey: key)
        } else {
            var dictionary: [String:Data] = [:]
            dictionary[newKey] = value
            defaults.set(dictionary, forKey: key)
        }
    }

    func getAll() -> [String:Data] {
        return defaults.dictionary(forKey: key) as! [String : Data]
    }

    func getKeys() -> [String] {
        return Array(getAll().keys)
    }

    func getItem(key: String) -> Data {
        return getAll()[key]!
    }

    func keyExists(key: String) -> Bool {
        return getAll()[key] != nil
    }

    func purge() {
        defaults.removeObject(forKey: key)
    }
}
