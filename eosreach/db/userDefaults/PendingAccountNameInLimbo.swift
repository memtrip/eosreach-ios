import Foundation

class PendingAccountNameInLimbo {
    
    private let key = "PENDING_ACCOUNT_NAME"
    private let defaults = UserDefaults.standard
    
    func put(value: String) {
        defaults.set(value, forKey: key)
    }
    
    func get() -> String {
        if let accountName = defaults.string(forKey: key) {
            return accountName
        } else {
            return ""
        }
    }
    
    func clear() {
        defaults.removeObject(forKey: key)
    }
}
