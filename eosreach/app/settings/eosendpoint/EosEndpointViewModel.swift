import Foundation
import RxSwift

class EosEndpointViewModel: MxViewModel<EosEndpointIntent, EosEndpointResult, EosEndpointViewState> {

    override func dispatcher(intent: EosEndpointIntent) -> Observable<EosEndpointResult> {
        switch intent {
        case .idle:
            return just(EosEndpointResult.idle)
        case .changeEndpoint(let endpoint):
            return just(EosEndpointResult.onProgress)
        case .navigateToBlockProducerList:
            return just(EosEndpointResult.navigateToBlockProducerList)
        }
    }

    override func reducer(previousState: EosEndpointViewState, result: EosEndpointResult) -> EosEndpointViewState {
        switch result {
        case .idle:
            return EosEndpointViewState.idle
        case .onProgress:
            return EosEndpointViewState.onProgress
        case .onError(let message):
            return EosEndpointViewState.onError(message: message)
        case .onSuccess:
            return EosEndpointViewState.onSuccess
        case .navigateToBlockProducerList:
            return EosEndpointViewState.navigateToBlockProducerList
        }
    }
}
