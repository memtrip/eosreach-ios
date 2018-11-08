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
            return previousState
        case .onProgress:
            return previousState.copy(copy: { copy in
                copy.view = EosEndpointViewState.View.onProgress
            })
        case .onError(let message):
            return previousState.copy(copy: { copy in
                copy.view = EosEndpointViewState.View.onError(message: message)
            })
        case .onSuccess:
            return previousState.copy(copy: { copy in
                copy.view = EosEndpointViewState.View.onSuccess
            })
        case .navigateToBlockProducerList:
            return previousState.copy(copy: { copy in
                copy.view = EosEndpointViewState.View.navigateToBlockProducerList
            })
        }
    }
}
