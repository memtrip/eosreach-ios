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
        case .storekitError:
            storeKitHandler.billingConnectionDelegate.storekitError()
        case .paymentFailed:
            storeKitHandler.billingConnectionDelegate.success(skProduct: StubSkPrice.create())
        }
    }
    
    func cancel() {
    }
    
    func pay(product: SKProduct) {
        switch StoreKitStubStateHolder.shared.state {
        case .success:
            self.storeKitHandler.billingFlowDelegate.success(transactionIdentifier: "orbx")
        case .storekitError:
            fatalError("Impossible path, critical test failure.")
        case .cannotMakePayment:
            self.storeKitHandler.billingFlowDelegate.cannotMakePayment()
        case .paymentFailed:
            self.storeKitHandler.billingFlowDelegate.failed()
        }
    }
}

class StoreKitStubStateHolder {
    
    static let shared = StoreKitStubStateHolder()
    
    var state: StoreKitStubState = .success
}

enum StoreKitStubState {
    case success
    case storekitError
    case cannotMakePayment
    case paymentFailed
}
