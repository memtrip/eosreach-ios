import Foundation
import eosswift

class ChainApiModule {
    static func create() -> ChainApi {
        switch TargetSwitch.api() {
        case .stub:
            #if STUB
            return ChainApiFactory.create(
                rootUrl: "http://offline.com/",
                urlSession: StubUrlSession.shared.urlSession,
                useLogger: true)
            #else
            fatalError("TargetSwitch implementation error.")
            #endif
        case .dev:
            return ChainApiFactory.create(rootUrl: R.string.apiStrings.dev_endpoint())
        case .prod:
            return ChainApiFactory.create(rootUrl: EosEndpoint().get())
        }
    }
}
