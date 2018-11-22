import Foundation
import RxSwift

class DelegateBandwidthViewModel: MxViewModel<DelegateBandwidthIntent, DelegateBandwidthResult, DelegateBandwidthViewState> {
    
    override func dispatcher(intent: DelegateBandwidthIntent) -> Observable<DelegateBandwidthResult> {
        switch intent {
        case .idle:
            return just(DelegateBandwidthResult.idle)
        }
    }

    override func reducer(previousState: DelegateBandwidthViewState, result: DelegateBandwidthResult) -> DelegateBandwidthViewState {
        switch result {
        case .idle:
            return DelegateBandwidthViewState.idle
        }
    }
}
