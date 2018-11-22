import Foundation
import RxSwift

class AllocatedBandwidthViewModel: MxViewModel<AllocatedBandwidthIntent, AllocatedBandwidthResult, AllocatedBandwidthViewState> {
    
    let getBandwidthRequest = GetBandwidthRequestImpl()
    
    override func dispatcher(intent: AllocatedBandwidthIntent) -> Observable<AllocatedBandwidthResult> {
        switch intent {
        case .idle:
            return just(AllocatedBandwidthResult.idle)
        case .start(let accountName):
            return getDelegatedBandwidth(accountName: accountName)
        case .navigateToUndelegateBandwidth(let delegatedBandwidth):
            return just(AllocatedBandwidthResult.navigateToUndelegateBandwidth(delegatedBandwidth: delegatedBandwidth))
        }
    }

    override func reducer(previousState: AllocatedBandwidthViewState, result: AllocatedBandwidthResult) -> AllocatedBandwidthViewState {
        switch result {
        case .idle:
            return AllocatedBandwidthViewState.idle
        case .onProgress:
            return AllocatedBandwidthViewState.onProgress
        case .populate(let bandwidth):
            return AllocatedBandwidthViewState.populate(bandwidth: bandwidth)
        case .onError:
            return AllocatedBandwidthViewState.onError
        case .empty:
            return AllocatedBandwidthViewState.empty
        case .navigateToUndelegateBandwidth(let delegatedBandwidth):
            return AllocatedBandwidthViewState.navigateToUndelegateBandwidth(delegatedBandwidth: delegatedBandwidth)
        }
    }
    
    private func getDelegatedBandwidth(accountName: String) -> Observable<AllocatedBandwidthResult> {
        return getBandwidthRequest.getBandwidth(accountName: accountName).map { result in
            if (result.success()) {
                return AllocatedBandwidthResult.populate(bandwidth: result.data!)
            } else {
                return self.delegatedBandwidthError(getBandwidthError: result.error!)
            }
        }.asObservable().startWith(AllocatedBandwidthResult.onProgress)
    }
    
    private func delegatedBandwidthError(getBandwidthError: GetBandwidthError) -> AllocatedBandwidthResult {
        switch getBandwidthError {
        case .empty:
            return AllocatedBandwidthResult.empty
        case .genericError:
            return AllocatedBandwidthResult.onError
        }
    }
}
