import Foundation

class EosPriceCurrencyPair {

    private let key = "EOS_PRICE_CURRENCY_PAIR"
    private let defaults = UserDefaults.standard

    func put(value: String) {
        defaults.set(value, forKey: key)
    }

    func get() -> String {
        if let value = defaults.string(forKey: key) {
            return value
        } else {
            return R.string.appStrings.app_default_currency()
        }
    }
}
