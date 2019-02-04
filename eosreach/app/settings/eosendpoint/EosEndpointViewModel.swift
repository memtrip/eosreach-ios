import Foundation
import RxSwift

class EosEndpointViewModel: MxViewModel<EosEndpointIntent, EosEndpointResult, EosEndpointViewState> {

    private let eosEndpoint = EosEndpoint()
    private let eosEndpointUseCase = EosEndpointUseCase()
    
    override func dispatcher(intent: EosEndpointIntent) -> Observable<EosEndpointResult> {
        switch intent {
        case .idle:
            return just(EosEndpointResult.idle)
        case .changeEndpoint(let endpoint):
            return changeEndpoint(endpointUrl: endpoint)
        case .navigateToBlockProducerList:
            return just(EosEndpointResult.navigateToBlockProducerList)
        }
    }

    override func reducer(previousState: EosEndpointViewState, result: EosEndpointResult) -> EosEndpointViewState {
        switch result {
        case .idle:
            return previousState.copy { copy in
                copy.view = EosEndpointViewState.View.idle
            }
        case .onProgress:
            return previousState.copy { copy in
                copy.view = EosEndpointViewState.View.onProgress
            }
        case .onSuccess(let url):
            return previousState.copy { copy in
                copy.view = EosEndpointViewState.View.onSuccess
                copy.endpointUrl = url
            }
        case .navigateToBlockProducerList:
            return previousState.copy { copy in
                copy.view = EosEndpointViewState.View.navigateToBlockProducerList
            }
        case .onErrorInvalidUrl:
            return previousState.copy { copy in
                copy.view = EosEndpointViewState.View.onErrorInvalidUrl
            }
        case .onErrorNothingChanged:
            return previousState.copy { copy in
                copy.view = EosEndpointViewState.View.onErrorNothingChanged
            }
        case .onErrorGeneric:
            return previousState.copy { copy in
                copy.view = EosEndpointViewState.View.onErrorGeneric
            }
        }
    }
    
    private func changeEndpoint(endpointUrl: String) -> Observable<EosEndpointResult> {
        let endpointWithPrefix: String
        if (!endpointUrl.hasSuffix("/")) {
            endpointWithPrefix = "\(endpointUrl)/"
        } else {
            endpointWithPrefix = endpointUrl
        }
        if ((!endpointWithPrefix.starts(with: "http://") && !endpointWithPrefix.starts(with: "https://")) || !validUrl(url: endpointWithPrefix)) {
            return Observable.just(EosEndpointResult.onErrorInvalidUrl)
        } else if (endpointWithPrefix == eosEndpoint.get()) {
            return Observable.just(EosEndpointResult.onErrorNothingChanged)
        } else {
            return eosEndpointUseCase.getInfo(endpointUrl: endpointWithPrefix).map { result in
                if (result.success()) {
                    self.eosEndpoint.put(value: endpointWithPrefix)
                    return EosEndpointResult.onSuccess(url: endpointWithPrefix)
                } else {
                    return EosEndpointResult.onErrorGeneric
                }
            }.asObservable().startWith(EosEndpointResult.onProgress)
        }
    }
    
    private func validUrl(url: String) -> Bool {
        let url = URL.init(string: url)
        return url != nil
    }
}
