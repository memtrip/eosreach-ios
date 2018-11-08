import Foundation
import RxSwift

class RegisteredBlockProducersViewModel: MxViewModel<RegisteredBlockProducersIntent, RegisteredBlockProducersResult, RegisteredBlockProducersViewState> {

    override func dispatcher(intent: RegisteredBlockProducersIntent) -> Observable<RegisteredBlockProducersResult> {
        switch intent {
        case .idle:
            return just(RegisteredBlockProducersResult.idle)
        }
    }

    override func reducer(previousState: RegisteredBlockProducersViewState, result: RegisteredBlockProducersResult) -> RegisteredBlockProducersViewState {
        switch result {
        case .idle:
            return RegisteredBlockProducersViewState.idle
        }
    }
}
