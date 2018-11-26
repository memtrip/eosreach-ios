import Foundation

class UnusedPublicKeyNoAccountsSynced {
    
    private let key = "UNSED_PUBLIC_KEY_NO_ACCOUNTS_SYNCED"
    private let defaults = UserDefaults.standard
    
    func put(value: Bool) {
        defaults.set(value, forKey: key)
    }
    
    func get() -> Bool {
        return defaults.bool(forKey: key)
    }
    
    func clear() {
        defaults.removeObject(forKey: key)
    }
}
