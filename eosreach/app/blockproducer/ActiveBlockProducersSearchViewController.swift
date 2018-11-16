import UIKit
import RxSwift
import RxCocoa

class ActiveBlockProducersViewController
    : MxViewController<ActiveBlockProducersIntent, ActiveBlockProducersResult, ActiveBlockProducersViewState, ActiveBlockProducersViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func intents() -> Observable<ActiveBlockProducersIntent> {
        return Observable.merge(
            Observable.just(ActiveBlockProducersIntent.idle)
        )
    }

    override func idleIntent() -> ActiveBlockProducersIntent {
        return ActiveBlockProducersIntent.idle
    }

    override func render(state: ActiveBlockProducersViewState) {
        switch state {
        case .idle:
            print("")
        }
    }

    override func provideViewModel() -> ActiveBlockProducersViewModel {
        return ActiveBlockProducersViewModel(initialState: ActiveBlockProducersViewState.idle)
    }
}
