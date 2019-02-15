import Foundation
import StoreKit

class StoreKitRequestStub : StoreKitRequest {
    
    private let storeKitHandler: StoreKitHandler
    private let skProductsRequest: SKProductsRequest
    
    required init(storeKitHandler: StoreKitHandler, skProductsRequest: SKProductsRequest) {
        self.storeKitHandler = storeKitHandler
        self.skProductsRequest = skProductsRequest
    }

    func start() {
        switch StoreKitStubStateHolder.shared.state {
        case .success:
            let skProduct = SKProduct()
            storeKitHandler.billingConnectionDelegate!.success(skProduct: skProduct)
        }
    }
    
    func cancel() {
    }
}

class StoreKitStubStateHolder {
    
    static let shared = StoreKitStubStateHolder()
    
    var state: StoreKitStubState = .success
}

enum StoreKitStubState {
    case success
}
