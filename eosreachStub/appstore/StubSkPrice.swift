import Foundation
import StoreKit

class StubSkPrice : SKProduct {
    
    init(identifier: String, price: String, priceLocale: Locale) {
        super.init()
        self.setValue(identifier, forKey: "productIdentifier")
        self.setValue(NSDecimalNumber(string: price), forKey: "price")
        self.setValue(priceLocale, forKey: "priceLocale")
    }
    
    static func create() -> SKProduct {
        return StubSkPrice(
            identifier: "xyz",
            price: "2.99",
            priceLocale: Locale.current)
    }
}
