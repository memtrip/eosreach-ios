import Foundation
import RxSwift

class ResourcesViewModel: MxViewModel<ResourcesIntent, ResourcesResult, ResourcesViewState> {

    override func dispatcher(intent: ResourcesIntent) -> Observable<ResourcesResult> {
        switch intent {
        case .idle:
            return just(ResourcesResult.idle)
        case .start(let eosAccount):
            return just(ResourcesResult.populate(eosAccount: eosAccount))
        case .navigateToManageBandwidth:
            return just(ResourcesResult.navigateToManageBandwidth)
        case .navigateToManageBandwidthWithAccountName(let accountName):
            return just(ResourcesResult.navigateToManageBandwidthWithAccountName)
        case .navigateToManageRam:
            return just(ResourcesResult.navigateToManageRam)
        }
    }

    override func reducer(previousState: ResourcesViewState, result: ResourcesResult) -> ResourcesViewState {
        switch result {
        case .idle:
            return ResourcesViewState.idle
        case .populate(let eosAccount):
            return ResourcesViewState.populate(eosAccount: eosAccount)
        case .navigateToManageBandwidth:
            return ResourcesViewState.navigateToManageBandwidth
        case .navigateToManageBandwidthWithAccountName:
            return ResourcesViewState.navigateToManageBandwidthWithAccountName
        case .navigateToManageRam:
            return ResourcesViewState.navigateToManageRam
        }
    }
}
