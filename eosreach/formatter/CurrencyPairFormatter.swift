import Foundation

struct CurrencyPairFormatter {

    static func formatAmountCurrencyPairValue(amount: Double, eosPrice: EosPrice) -> String {
        if (eosPrice.unavailable) {
            return ""
        } else {
            let fiatPrice = amount * eosPrice.value
            return formatCurrencyPairValue(price: fiatPrice, currencyCode: eosPrice.currency)
        }
    }

    static func formatCurrencyPairValue(price: Double, currencyCode: String) -> String {
        let currencySymbolResult = currencySymbol(symbol: currencyCode)
        let priceString = formatBalanceString(price: price, isCrypto: currencySymbolResult.isCrypto)
        return "\(currencySymbolResult.symbol)\(priceString)"
    }

    static func currencySymbol(symbol: String) -> CurrencySymbol {
        if let symbol = getSymbol(forCurrencyCode: symbol) {
            return CurrencySymbol(symbol: symbol, isCrypto: false)
        } else {
            return CurrencySymbol(symbol: "\(symbol) ", isCrypto: true)
        }
    }

    static func getSymbol(forCurrencyCode code: String) -> String? {
        let locale = NSLocale(localeIdentifier: code)
        return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code)
    }

    static func formatBalanceString(price: Double, isCrypto: Bool) -> String {
        if (isCrypto) {
            return String(format: "%.05f", price)
        } else {
            return String(format: "%.02f", price)
        }
    }
}
