import Foundation
import StoreKit

class StoreKitRequestImpl : StoreKitRequest {
    
    private let storeKitHandler: StoreKitHandler
    private let skProductsRequest: SKProductsRequest
    
    required init(storeKitHandler: StoreKitHandler, skProductsRequest: SKProductsRequest) {
        self.storeKitHandler = storeKitHandler
        self.skProductsRequest = skProductsRequest
        self.skProductsRequest.delegate = storeKitHandler
    }
    
    func start() {
        self.skProductsRequest.start()
    }
    
    func cancel() {
        self.skProductsRequest.cancel()
    }
    
    func pay(product: SKProduct)  {
        if (SKPaymentQueue.canMakePayments()) {
            SKPaymentQueue.default().add(storeKitHandler)
            SKPaymentQueue.default().add(SKPayment(product: product))
        } else {
            self.storeKitHandler.billingFlowDelegate.cannotMakePayment()
        }
    }
}

protocol StoreKitRequest {
    init(storeKitHandler: StoreKitHandler, skProductsRequest: SKProductsRequest)
    func start()
    func cancel()
    func pay(product: SKProduct)
}
