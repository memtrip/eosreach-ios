import Foundation
import eosswift

class ChainApiModule {
    static func create() -> ChainApi {
        if (true) {
            return ChainApiFactory.create(rootUrl: EosEndpoint().get())
        } else {
            return ChainApiFactory.create(rootUrl: EosEndpoint().get(), useLogger: true)
        }
    }
}
