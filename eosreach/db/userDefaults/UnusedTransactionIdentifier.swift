import Foundation

class UnusedTransactionIdentifier {

    private let key = "UNSED_TRANSACTION_IDENTIFIER"
    private let defaults = UserDefaults.standard

    func put(value: String) {
        defaults.set(value, forKey: key)
    }

    func get() -> String {
        if let unusedPurchaseToken = defaults.string(forKey: key) {
            return unusedPurchaseToken
        } else {
            return ""
        }
    }
    
    func clear() {
        defaults.removeObject(forKey: key)
    }
}
