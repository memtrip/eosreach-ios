import Foundation

class AccountListSelection {

    private let key = "ACCOUNT_LIST_SELECTION"
    private let defaults = UserDefaults.standard

    func put(value: String) {
        defaults.set(value, forKey: key)
    }

    func get() -> String {
        if let value = defaults.string(forKey: key) {
            return value
        } else {
            return ""
        }
    }
    
    func clear() {
        defaults.removeObject(forKey: key)
    }
}
