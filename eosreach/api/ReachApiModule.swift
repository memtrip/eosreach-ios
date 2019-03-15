import Foundation

class ReachApiModule {
    
    static func eosPriceApi() -> EosPriceApi {
        switch TargetSwitch.api() {
        case .stub:
            return EosPriceApi(StubUrlSession.shared.urlSession)
        case .dev:
            return EosPriceApi(StubUrlSession.shared.urlSession)
        case .prod:
            return EosPriceApi(URLSession.shared)
        }
    }
    
    static func eosCreateAccountApi() -> EosCreateAccountApi {
        switch TargetSwitch.api() {
        case .stub:
            return EosCreateAccountApi(StubUrlSession.shared.urlSession)
        case .dev:
            fatalError("create account api is not implemented in DEV target")
        case .prod:
            return EosCreateAccountApi(URLSession.shared)
        }
    }
    
    static func receiptDataRequest() -> ReceiptDataRequest {
        switch TargetSwitch.api() {
        case .stub:
            return ReceiptDataRequestStub()
        case .dev:
            fatalError("receipt data is not implemented in DEV target")
        case .prod:
            return ReceiptDataRequestImpl()
        }
    }
}
