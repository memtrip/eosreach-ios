import Foundation
import RxSwift

class ActiveBlockProducersViewModel: MxViewModel<ActiveBlockProducersIntent, ActiveBlockProducersResult, ActiveBlockProducersViewState> {

    private let blockProducerRequest = BlockProducerRequestImpl()
    
    override func dispatcher(intent: ActiveBlockProducersIntent) -> Observable<ActiveBlockProducersResult> {
        switch intent {
        case .idle:
            return just(ActiveBlockProducersResult.idle)
        case .start:
            return getBlockProducerList()
        case .retry:
            return getBlockProducerList()
        case .blockProducerSelected(let blockProducerDetails):
            return just(ActiveBlockProducersResult.blockProducerSelected(blockProducer: blockProducerDetails))
        case .blockProducerInformationSelected(let blockProducerDetails):
            return just(ActiveBlockProducersResult.blockProducerInformationSelected(blockProducer: blockProducerDetails))
        }
    }

    override func reducer(previousState: ActiveBlockProducersViewState, result: ActiveBlockProducersResult) -> ActiveBlockProducersViewState {
        switch result {
        case .idle:
            return ActiveBlockProducersViewState.idle
        case .onProgress:
            return ActiveBlockProducersViewState.onProgress
        case .onError:
            return ActiveBlockProducersViewState.onError
        case .onSuccess(let blockProducerList):
            return ActiveBlockProducersViewState.onSuccess(blockProducerList: blockProducerList)
        case .blockProducerSelected(let blockProducer):
            return ActiveBlockProducersViewState.blockProducerSelected(blockProducer: blockProducer)
        case .blockProducerInformationSelected(let blockProducer):
            return ActiveBlockProducersViewState.blockProducerInformationSelected(blockProducer: blockProducer)
        }
    }
    
    private func getBlockProducerList() -> Observable<ActiveBlockProducersResult> {
        return blockProducerRequest.getBlockProducers(limit: 50).map { response in
                if (response.success()) {
                    return ActiveBlockProducersResult.onSuccess(blockProducerList: response.data!)
                } else {
                    return ActiveBlockProducersResult.onError
                }
        }.asObservable().startWith(ActiveBlockProducersResult.onProgress)
    }
}
