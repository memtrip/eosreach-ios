import Foundation
import eosswift

class ChainApiModule {
    static func create() -> ChainApi {
        return ChainApiFactory.create(rootUrl: EosEndpoint().get())
    }
}
