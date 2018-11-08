import Foundation

class EosPriceValue {

    private let key = "EOS_PRICE"
    private let defaults = UserDefaults.standard

    func put(value: Float) {
        defaults.set(value, forKey: key)
    }

    func get() -> Float {
        return defaults.float(forKey: key)
    }
}
