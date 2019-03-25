import Foundation

class ReachApiModule {
    
    static func eosPriceApi() -> EosPriceApi {
        switch TargetSwitch.api() {
        case .stub:
            #if STUB
            return EosPriceApi(StubUrlSession.shared.urlSession)
            #else
            fatalError("TargetSwitch implementation error.")
            #endif
        case .dev:
            return EosPriceApi(URLSession.shared)
        case .prod:
            return EosPriceApi(URLSession.shared)
        }
    }
    
    static func eosCreateAccountApi() -> EosCreateAccountApi {
        switch TargetSwitch.api() {
        case .stub:
            #if STUB
            return EosCreateAccountApi(StubUrlSession.shared.urlSession)
            #else
            fatalError("TargetSwitch implementation error.")
            #endif
        case .dev:
            fatalError("create account api is not implemented in DEV target")
        case .prod:
            return EosCreateAccountApi(URLSession.shared)
        }
    }
    
    static func receiptDataRequest() -> ReceiptDataRequest {
        switch TargetSwitch.api() {
        case .stub:
            #if STUB
            return ReceiptDataRequestStub()
            #else
            fatalError("TargetSwitch implementation error.")
            #endif
        case .dev:
            fatalError("receipt data is not implemented in DEV target")
        case .prod:
            return ReceiptDataRequestImpl()
        }
    }
}
