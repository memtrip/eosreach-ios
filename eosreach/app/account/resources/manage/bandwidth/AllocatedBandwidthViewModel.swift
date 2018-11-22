import Foundation
import RxSwift

class AllocatedBandwidthViewModel: MxViewModel<AllocatedBandwidthIntent, AllocatedBandwidthResult, AllocatedBandwidthViewState> {
    
    override func dispatcher(intent: AllocatedBandwidthIntent) -> Observable<AllocatedBandwidthResult> {
        switch intent {
        case .idle:
            return just(AllocatedBandwidthResult.idle)
        }
    }

    override func reducer(previousState: AllocatedBandwidthViewState, result: AllocatedBandwidthResult) -> AllocatedBandwidthViewState {
        switch result {
        case .idle:
            return AllocatedBandwidthViewState.idle
        }
    }
}
