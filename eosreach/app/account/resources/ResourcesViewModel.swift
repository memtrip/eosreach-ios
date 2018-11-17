import Foundation
import RxSwift

class ResourcesViewModel: MxViewModel<ResourcesIntent, ResourcesResult, ResourcesViewState> {

    override func dispatcher(intent: ResourcesIntent) -> Observable<ResourcesResult> {
        switch intent {
        case .idle:
            fatalError()
        case .start(let eosAccount, let contractAccountBalance):
            fatalError()
        case .navigateToManageBandwidth:
            fatalError()
        case .navigateToManageBandwidthWithAccountName(let accountName):
            fatalError()
        case .navigateToManageRam:
            fatalError()
        case .requestRefund(let accountName):
            fatalError()
        }
    }

    override func reducer(previousState: ResourcesViewState, result: ResourcesResult) -> ResourcesViewState {
        switch result {
        case .idle:
            fatalError()
        case .populate(let eosAccount, let contractAccountBalance):
            fatalError()
        case .navigateToManageBandwidth:
            fatalError()
        case .navigateToManageBandwidthWithAccountName:
            fatalError()
        case .navigateToManageRam:
            fatalError()
        case .refundProgress:
            fatalError()
        case .refundSuccess:
            fatalError()
        case .refundFailed:
            fatalError()
        case .refundFailedWithLog(let log):
            fatalError()
        }
    }
}
