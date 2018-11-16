import Foundation
import RxSwift

class RegisteredBlockProducersViewModel: MxViewModel<RegisteredBlockProducersIntent, RegisteredBlockProducersResult, RegisteredBlockProducersViewState> {

    private let registeredBlockProducerRequest = RegisteredBlockProducerRequestImpl()

    private func getRegisteredBlockProducers(nextAccount: String = "") -> Observable<RegisteredBlockProducersResult> {
        return registeredBlockProducerRequest.getProducers(limit: 200, lowerLimit: nextAccount).map { result in
            if (result.success()) {
                return RegisteredBlockProducersResult.onSuccess(registeredBlockProducers: result.data!)
            } else {
                return RegisteredBlockProducersResult.onError
            }
        }.asObservable().startWith(RegisteredBlockProducersResult.onProgress)
    }

    override func dispatcher(intent: RegisteredBlockProducersIntent) -> Observable<RegisteredBlockProducersResult> {
        switch intent {
        case .idle:
            return just(RegisteredBlockProducersResult.idle)
        case .start:
            return self.getRegisteredBlockProducers()
        case .retry:
            return self.getRegisteredBlockProducers()
        case .loadMore(let lastAccountName):
            return self.getRegisteredBlockProducers(nextAccount: lastAccountName)
        case .websiteSelected(let website):
            return just(RegisteredBlockProducersResult.websiteSelected(url: website))
        case .registeredBlockProducersSelected(let accountName):
            return just(RegisteredBlockProducersResult.registeredBlockProducersSelected(accountName: accountName))
        }
    }

    override func reducer(previousState: RegisteredBlockProducersViewState, result: RegisteredBlockProducersResult) -> RegisteredBlockProducersViewState {
        switch result {
        case .idle:
            return RegisteredBlockProducersViewState.idle
        case .onProgress:
            return RegisteredBlockProducersViewState.onProgress
        case .empty:
            return RegisteredBlockProducersViewState.empty
        case .onLoadMoreProgress:
            return RegisteredBlockProducersViewState.onLoadMoreProgress
        case .onError:
            return RegisteredBlockProducersViewState.onError
        case .onLoadMoreError:
            return RegisteredBlockProducersViewState.onLoadMoreError
        case .onSuccess(let registeredBlockProducers):
            return RegisteredBlockProducersViewState.onSuccess(registeredBlockProducers: registeredBlockProducers)
        case .websiteSelected(let url):
            return RegisteredBlockProducersViewState.websiteSelected(url: url)
        case .registeredBlockProducersSelected(let accountName):
            return RegisteredBlockProducersViewState.registeredBlockProducersSelected(accountName: accountName)
        }
    }
}
