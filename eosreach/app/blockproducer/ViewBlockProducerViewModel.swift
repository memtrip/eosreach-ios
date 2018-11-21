import Foundation
import RxSwift

class ViewBlockProducerViewModel: MxViewModel<ViewBlockProducerIntent, ViewBlockProducerResult, ViewBlockProducerViewState> {

    private let blockProducerRequest = BlockProducerRequestImpl()
    
    override func dispatcher(intent: ViewBlockProducerIntent) -> Observable<ViewBlockProducerResult> {
        switch intent {
        case .idle:
            return just(ViewBlockProducerResult.idle)
        case .start(let accountName, let blockProducerDetails):
            return start(accountName: accountName, blockProducerDetails: blockProducerDetails)
        case .navigateToUrl(let url):
            return just(validUrl(url: url))
        case .sendEmail(let email):
            return just(ViewBlockProducerResult.sendEmail(email: email))
        case .navigateToOwnerAccount(let owner):
            return just(ViewBlockProducerResult.navigateToOwnerAccount(owner: owner))
        }
    }

    override func reducer(previousState: ViewBlockProducerViewState, result: ViewBlockProducerResult) -> ViewBlockProducerViewState {
        switch result {
        case .idle:
            return ViewBlockProducerViewState.idle
        case .onProgress:
            return ViewBlockProducerViewState.onProgress
        case .onError:
            return ViewBlockProducerViewState.onError
        case .onChainProducerJsonMissing:
            return ViewBlockProducerViewState.onError
        case .onInvalidUrl(let url):
            return ViewBlockProducerViewState.onInvalidUrl(url: url)
        case .navigateToUrl(let url):
            return ViewBlockProducerViewState.navigateToUrl(url: url)
        case .populate(let blockProducerDetails):
            return ViewBlockProducerViewState.populate(blockProducerDetails: blockProducerDetails)
        case .sendEmail(let email):
            return ViewBlockProducerViewState.sendEmail(email: email)
        case .navigateToOwnerAccount(let owner):
            return ViewBlockProducerViewState.navigateToOwnerAccount(owner: owner)
        }
    }
    
    private func start(accountName: String?, blockProducerDetails: BlockProducerDetails?) -> Observable<ViewBlockProducerResult> {
        if (accountName != nil) {
            return getBlockProducerByAccountName(accountName: accountName!)
        } else {
            return just(ViewBlockProducerResult.populate(blockProducerDetails: blockProducerDetails!))
        }
    }
    
    private func validUrl(url: String) -> ViewBlockProducerResult {
        if (checkUrl(url: url)) {
            return ViewBlockProducerResult.navigateToUrl(url: url)
        } else {
            return ViewBlockProducerResult.onInvalidUrl(url: url)
        }
    }
    
    private func checkUrl(url: String) -> Bool {
        let url = URL.init(string: url)
        return url != nil
    }
    
    private func getBlockProducerByAccountName(accountName: String) -> Observable<ViewBlockProducerResult> {
        return blockProducerRequest.getSingleBlockProducer(accountName: accountName).map { result in
            if (result.success()) {
                return ViewBlockProducerResult.populate(blockProducerDetails: result.data!)
            } else {
                return self.blockProducerError(blockProducerError: result.error!)
            }
        }.catchErrorJustReturn(ViewBlockProducerResult.onError)
            .asObservable()
            .startWith(ViewBlockProducerResult.onProgress)
    }
    
    private func blockProducerError(blockProducerError: BlockProducerError) -> ViewBlockProducerResult {
        switch blockProducerError {
        case .genericError:
            return ViewBlockProducerResult.onError
        case .onChainProducerJsonMissing:
            return ViewBlockProducerResult.onChainProducerJsonMissing
        }
    }
}
