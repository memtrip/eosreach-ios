import Foundation
import eosswift

class ChainApiModule {
    static func create() -> ChainApi {
        switch TargetSwitch.api() {
        case .stub:
            return ChainApiFactory.create(
                rootUrl: "http://offline.com/",
                urlSession: StubUrlSession.shared.urlSession,
                useLogger: true)
        case .prod:
            return ChainApiFactory.create(rootUrl: EosEndpoint().get())
        }
    }
}
