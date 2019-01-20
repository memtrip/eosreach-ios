import Foundation

class ReachApiModule {
    static func eosPriceApi() -> EosPriceApi {
        switch TargetSwitch.api() {
        case .stub:
            return EosPriceApi(StubUrlSession.shared.urlSession)
        case .prod:
            return EosPriceApi(URLSession.shared)
        }
    }
    
    static func eosCreateAccountApi() -> EosCreateAccountApi {
        switch TargetSwitch.api() {
        case .stub:
            return EosCreateAccountApi(StubUrlSession.shared.urlSession)
        case .prod:
            return EosCreateAccountApi(URLSession.shared)
        }
    }
}
