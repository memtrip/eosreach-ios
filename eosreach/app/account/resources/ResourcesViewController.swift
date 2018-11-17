import UIKit
import RxSwift
import RxCocoa

class ResourcesViewController: MxViewController<ResourcesIntent, ResourcesResult, ResourcesViewState, ResourcesViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func intents() -> Observable<ResourcesIntent> {
        return Observable.merge(
            Observable.just(ResourcesIntent.idle),
            Observable.just(ResourcesIntent.idle)
        )
    }

    override func idleIntent() -> ResourcesIntent {
        return ResourcesIntent.idle
    }

    override func render(state: ResourcesViewState) {
        switch state {
        case .idle:
            print("")
        case .populate(let eosAccount, let contractAccountBalance):
            print("")
        case .navigateToManageBandwidth:
            print("")
        case .navigateToManageBandwidthWithAccountName:
            print("")
        case .navigateToManageRam:
            print("")
        case .refundProgress:
            print("")
        case .refundSuccess:
            print("")
        case .refundFailed:
            print("")
        case .refundFailedWithLog(let log):
            print("")
        }
    }

    override func provideViewModel() -> ResourcesViewModel {
        return ResourcesViewModel(initialState: ResourcesViewState.idle)
    }
}
