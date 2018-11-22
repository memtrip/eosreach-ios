import UIKit
import RxSwift
import RxCocoa

class UndelegateBandwidthViewController
: MxViewController<UndelegateBandwidthIntent, UndelegateBandwidthResult, UndelegateBandwidthViewState, UndelegateBandwidthViewModel> {
    
    var manageBandwidthBundle: ManageBandwidthBundle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func intents() -> Observable<UndelegateBandwidthIntent> {
        return Observable.merge(
            Observable.just(UndelegateBandwidthIntent.idle)
        )
    }

    override func idleIntent() -> UndelegateBandwidthIntent {
        return UndelegateBandwidthIntent.idle
    }

    override func render(state: UndelegateBandwidthViewState) {
        switch state {
        case .idle:
            break
        }
    }

    override func provideViewModel() -> UndelegateBandwidthViewModel {
        return UndelegateBandwidthViewModel(initialState: UndelegateBandwidthViewState.idle)
    }
}
