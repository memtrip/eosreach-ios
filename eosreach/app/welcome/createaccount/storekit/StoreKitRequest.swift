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
    
    func getStoreKitHandler() -> StoreKitHandler {
        return storeKitHandler
    }
}

protocol StoreKitRequest {
    init(storeKitHandler: StoreKitHandler, skProductsRequest: SKProductsRequest)
    func start()
    func cancel()
    func getStoreKitHandler() -> StoreKitHandler
}
