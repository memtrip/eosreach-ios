import Foundation
import StoreKit

class StoreKitRequestImpl : StoreKitRequest {
    
    private let skProductsRequest: SKProductsRequest
    
    required init(storeKitHandler: StoreKitHandler, skProductsRequest: SKProductsRequest) {
        self.skProductsRequest = skProductsRequest
        self.skProductsRequest.delegate = storeKitHandler
    }
    
    func start() {
        self.skProductsRequest.start()
    }
    
    func cancel() {
        self.skProductsRequest.cancel()
    }
}

protocol StoreKitRequest {
    
    init(storeKitHandler: StoreKitHandler, skProductsRequest: SKProductsRequest)
    
    func start()
    
    func cancel()
}
