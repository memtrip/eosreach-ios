import Foundation
import StoreKit

class StoreKitRequestFactory {
    
    func create(storeKitHandler: StoreKitHandler, skProductsRequest: SKProductsRequest) -> StoreKitRequest {
        switch TargetSwitch.api() {
        case .stub:
            return StoreKitRequestStub(
                storeKitHandler: storeKitHandler,
                skProductsRequest: skProductsRequest)
        case .prod:
            return StoreKitRequestImpl(
                storeKitHandler: storeKitHandler,
                skProductsRequest: skProductsRequest)
        }
    }
}
