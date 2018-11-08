import UIKit
import RxSwift
import RxCocoa

class RegisteredBlockProducersViewController
    : MxViewController<RegisteredBlockProducersIntent, RegisteredBlockProducersResult, RegisteredBlockProducersViewState, RegisteredBlockProducersViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func intents() -> Observable<RegisteredBlockProducersIntent> {
        return Observable.merge(
            Observable.just(RegisteredBlockProducersIntent.idle)
        )
    }

    override func idleIntent() -> RegisteredBlockProducersIntent {
        return RegisteredBlockProducersIntent.idle
    }

    override func render(state: RegisteredBlockProducersViewState) {
        switch state {
        case .idle:
            print("")
        }
    }

    override func provideViewModel() -> RegisteredBlockProducersViewModel {
        return RegisteredBlockProducersViewModel(initialState: RegisteredBlockProducersViewState.idle)
    }
}
