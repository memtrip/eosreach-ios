import Foundation
import eosswift

class HistoryApiModule {
    static func create() -> HistoryApi {
        switch TargetSwitch.api() {
        case .stub:
            #if STUB
            return HistoryApiFactory.create(
                rootUrl: "http://offline.com/",
                urlSession: StubUrlSession.shared.urlSession,
                useLogger: true)
            #else
            fatalError("TargetSwitch implementation error.")
            #endif
        case .dev:
            return HistoryApiFactory.create(rootUrl: R.string.apiStrings.dev_endpoint())
        case .prod:
            return HistoryApiFactory.create(rootUrl: EosEndpoint().get())
        }
    }
}
