import Foundation

class BalanceFormatter {

    static func deserialize(balance: String) -> Balance {
        let parts = balance.split(separator: " ")
        return Balance(
            amount: Double(parts[0])!,
            symbol: String(parts[1]))
    }

    static func create(amount: String, symbol: String) -> Balance {
        if (amount == "") {
            return create(amount: 0.0, symbol: symbol)
        } else {
            return create(amount: Double(amount)!, symbol: symbol)
        }
    }

    static func create(amount: Double, symbol: String) -> Balance {
        return Balance(amount: amount, symbol: symbol)
    }

    static func formatEosBalance(amount: Double, symbol: String) -> String {
        return formatEosBalance(amount: String(amount), symbol: symbol)
    }

    static func formatEosBalance(amount: String, symbol: String) -> String {
        return formatEosBalance(balance: create(amount: amount, symbol: symbol))
    }

    static func formatEosBalance(balance: Balance) -> String {
        let value = formatBalanceDigits(amount: balance.amount)
        return "\(value) \(balance.symbol)"
    }

    static func formatBalanceDigits(amount: Double) -> String {
        return String(format: "%.4f", amount)
    }
}
