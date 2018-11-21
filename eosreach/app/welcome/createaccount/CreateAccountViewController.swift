import UIKit
import RxSwift
import RxCocoa

class CreateAccountViewController: MxViewController<CreateAccountIntent, CreateAccountResult, CreateAccountViewState, CreateAccountViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func intents() -> Observable<CreateAccountIntent> {
        return Observable.just(CreateAccountIntent.idle)
    }

    override func idleIntent() -> CreateAccountIntent {
        return CreateAccountIntent.idle
    }

    override func render(state: CreateAccountViewState) {
        switch state {
        case .idle:
            break
        }
    }

    override func provideViewModel() -> CreateAccountViewModel {
        return CreateAccountViewModel(initialState: CreateAccountViewState.idle)
    }
}
