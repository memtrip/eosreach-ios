import Foundation

class UnusedPublicKeyInLimbo {

    private let key = "UNSED_PUBLIC_KEY_IN_LIMBO"
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
