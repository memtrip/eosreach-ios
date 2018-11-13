import Foundation

struct ContractAccountBalance {
    let contractName: String
    let accountName: String
    let balance: Balance
    let exchangeRate: EosPrice
    let unavailable: Bool

    static func unavailable() -> ContractAccountBalance {
        return ContractAccountBalance(
            contractName: "unavailable",
            accountName: "unavailable",
            balance: Balance(amount: 0.0, symbol: "unavailable"),
            exchangeRate: EosPrice.unavailable(),
            unavailable: true)
    }
}
