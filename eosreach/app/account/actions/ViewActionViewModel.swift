import Foundation
import RxSwift

class ViewActionViewModel: MxViewModel<ViewActionIntent, ViewActionResult, ViewActionViewState> {
    
    override func dispatcher(intent: ViewActionIntent) -> Observable<ViewActionResult> {
        switch intent {
        case .idle:
            return just(ViewActionResult.idle)
        }
    }

    override func reducer(previousState: ViewActionViewState, result: ViewActionResult) -> ViewActionViewState {
        switch result {
        case .idle:
            return ViewActionViewState.idle
        }
    }
}
