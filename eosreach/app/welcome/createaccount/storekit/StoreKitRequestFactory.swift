import Foundation
import StoreKit

class StoreKitRequestFactory {
    
    static func create(storeKitHandler: StoreKitHandler) -> StoreKitRequest {
        switch TargetSwitch.api() {
        case .stub:
            return StoreKitRequestStub(
                storeKitHandler: storeKitHandler,
                skProductsRequest: SKProductsRequest(productIdentifiers: NSSet(object: "") as! Set<String>))
        case .dev:
            fatalError("StoreKit is not available in DEV target")
        case .prod:
            return StoreKitRequestImpl(
                storeKitHandler: storeKitHandler,
                skProductsRequest: SKProductsRequest(productIdentifiers:
                    NSSet(object: R.string.appStrings.app_create_account_product_id()) as! Set<String>))
        }
    }
}
