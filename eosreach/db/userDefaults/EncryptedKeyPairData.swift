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
        if let all = defaults.dictionary(forKey: key) {
            return all as! [String : Data]
        } else {
            return [:]
        }
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
