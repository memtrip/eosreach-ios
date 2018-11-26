import Foundation

class UnusedPublicKey {

    private let key = "UNSED_PUBLIC_KEY"
    private let defaults = UserDefaults.standard

    func put(value: String) {
        defaults.set(value, forKey: key)
    }

    func get() -> String {
        if let unusedPublicKey = defaults.string(forKey: key) {
            return unusedPublicKey
        } else {
            return ""
        }
    }
    
    func clear() {
        defaults.removeObject(forKey: key)
    }
}
