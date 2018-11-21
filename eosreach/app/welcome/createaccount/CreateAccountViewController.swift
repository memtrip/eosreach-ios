import UIKit
import RxSwift
import RxCocoa

class CreateAccountViewController: MxViewController<CreateAccountIntent, CreateAccountResult, CreateAccountViewState, CreateAccountViewModel> {

    @IBOutlet weak var toolBar: ReachToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toolBar.title = R.string.welcomeStrings.welcome_create_account_title()
        setToolbar(toolbar: toolBar)
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
