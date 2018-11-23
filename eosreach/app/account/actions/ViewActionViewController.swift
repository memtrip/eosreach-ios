import UIKit
import RxSwift
import RxCocoa

class ViewActionViewController : MxViewController<ViewActionIntent, ViewActionResult, ViewActionViewState, ViewActionViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func intents() -> Observable<ViewActionIntent> {
        return Observable.merge(
            Observable.just(ViewActionIntent.idle)
        )
    }

    override func idleIntent() -> ViewActionIntent {
        return ViewActionIntent.idle
    }

    override func render(state: ViewActionViewState) {
        switch state {
        case .idle:
            break
        }
    }

    override func provideViewModel() -> ViewActionViewModel {
        return ViewActionViewModel(initialState: ViewActionViewState.idle)
    }
}
