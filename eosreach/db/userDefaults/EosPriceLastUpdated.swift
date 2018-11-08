import Foundation

class EosPriceLastUpdated {

    private let key = "EOS_PRICE_LAST_UPDATED"
    private let defaults = UserDefaults.standard

    func put(value: Double) {
        defaults.set(value, forKey: key)
    }

    func get() -> Double {
        return defaults.double(forKey: key)
    }
}
