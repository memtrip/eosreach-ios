import Foundation
import RxSwift

class SellRamViewModel: MxViewModel<SellRamIntent, SellRamResult, SellRamViewState> {
    
    override func dispatcher(intent: SellRamIntent) -> Observable<SellRamResult> {
        switch intent {
        case .idle:
            return just(SellRamResult.idle)
        }
    }

    override func reducer(previousState: SellRamViewState, result: SellRamResult) -> SellRamViewState {
        switch result {
        case .idle:
            return SellRamViewState.idle
        }
    }
}
