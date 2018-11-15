import Foundation
import eosswift

class HistoryApiModule {
    static func create() -> HistoryApi {
        return HistoryApiFactory.create(rootUrl: EosEndpoint().get())
    }
}
