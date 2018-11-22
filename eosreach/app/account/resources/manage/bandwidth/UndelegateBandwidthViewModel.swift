import Foundation
import RxSwift

class UndelegateBandwidthViewModel: MxViewModel<UndelegateBandwidthIntent, UndelegateBandwidthResult, UndelegateBandwidthViewState> {
    
    override func dispatcher(intent: UndelegateBandwidthIntent) -> Observable<UndelegateBandwidthResult> {
        switch intent {
        case .idle:
            return just(UndelegateBandwidthResult.idle)
        }
    }

    override func reducer(previousState: UndelegateBandwidthViewState, result: UndelegateBandwidthResult) -> UndelegateBandwidthViewState {
        switch result {
        case .idle:
            return UndelegateBandwidthViewState.idle
        }
    }
}
