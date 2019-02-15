import Foundation
import StoreKit

class StoreKitRequestStub : StoreKitRequest {
    
    private let storeKitHandler: StoreKitHandler
    
    required init(storeKitHandler: StoreKitHandler, skProductsRequest: SKProductsRequest) {
        self.storeKitHandler = storeKitHandler
    }

    func start() {
        switch StoreKitStubStateHolder.shared.state {
        case .success:
            storeKitHandler.billingConnectionDelegate.success(skProduct: StubSkPrice.create())
        case .cannotMakePayment:
            storeKitHandler.billingConnectionDelegate.success(skProduct: StubSkPrice.create())
        }
    }
    
    func cancel() {
    }
    
    func pay(product: SKProduct) {
        switch StoreKitStubStateHolder.shared.state {
        case .success:
            self.storeKitHandler.billingFlowDelegate.success(transactionIdentifier: "orbx")
        case .cannotMakePayment:
            self.storeKitHandler.billingFlowDelegate.cannotMakePayment()
        }
    }
}

class StoreKitStubStateHolder {
    
    static let shared = StoreKitStubStateHolder()
    
    var state: StoreKitStubState = .success
}

enum StoreKitStubState {
    case success
    case cannotMakePayment
}
