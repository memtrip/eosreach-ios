import Foundation
import RxSwift

class ActiveBlockProducersViewModel: MxViewModel<ActiveBlockProducersIntent, ActiveBlockProducersResult, ActiveBlockProducersViewState> {

    override func dispatcher(intent: ActiveBlockProducersIntent) -> Observable<ActiveBlockProducersResult> {
        switch intent {
        case .idle:
            return just(ActiveBlockProducersResult.idle)
        }
    }

    override func reducer(previousState: ActiveBlockProducersViewState, result: ActiveBlockProducersResult) -> ActiveBlockProducersViewState {
        switch result {
        case .idle:
            return ActiveBlockProducersViewState.idle
        }
    }
}
