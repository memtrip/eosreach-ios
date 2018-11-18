import Foundation

struct ContractAccountBalance {
    let contractName: String
    let accountName: String
    let balance: Balance
    let exchangeRate: EosPrice
    let unavailable: Bool
    
    init(contractName: String, accountName: String, balance: Balance, exchangeRate: EosPrice) {
        self.contractName = contractName
        self.accountName = accountName
        self.balance = balance
        self.exchangeRate = exchangeRate
        self.unavailable = false
    }
    
    init(contractName: String, accountName: String, balance: Balance, exchangeRate: EosPrice, unavailable: Bool) {
        self.contractName = contractName
        self.accountName = accountName
        self.balance = balance
        self.exchangeRate = exchangeRate
        self.unavailable = unavailable
    }

    static func unavailable() -> ContractAccountBalance {
        return ContractAccountBalance(
            contractName: "unavailable",
            accountName: "unavailable",
            balance: Balance(amount: 0.0, symbol: "unavailable"),
            exchangeRate: EosPrice.unavailable(),
            unavailable: true)
    }
}
