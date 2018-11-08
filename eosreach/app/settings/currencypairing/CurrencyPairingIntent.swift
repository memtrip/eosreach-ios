import Foundation

enum CurrencyPairingIntent: MxIntent {
    case idle
    case currencyPair(currencyPair: String)
}
