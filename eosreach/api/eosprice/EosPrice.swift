import Foundation

struct EosPrice {
    let value: Double
    let currency: String
    let unavailable: Bool

    init(value: Double, currency: String) {
        self.value = value
        self.currency = currency
        self.unavailable = false
    }
    
    init(value: Double, currency: String, unavailable: Bool) {
        self.value = value
        self.currency = currency
        self.unavailable = unavailable
    }
    
    static func unavailable() -> EosPrice {
        return EosPrice(
            value: -1,
            currency: "-",
            unavailable: true)
    }
}
