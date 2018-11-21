import Foundation
import RxSwift

class ProxyVoterListViewModel: MxViewModel<ProxyVoterListIntent, ProxyVoterListResult, ProxyVoterListViewState> {

    private let proxyVoterRequest = ProxyVoterRequestImpl()
    
    override func dispatcher(intent: ProxyVoterListIntent) -> Observable<ProxyVoterListResult> {
        switch intent {
        case .idle:
            return just(ProxyVoterListResult.idle)
        case .start:
            return getProxyVoters()
        case .retry:
            return getProxyVoters()
        case .proxyVoterSelected(let proxyVoterDetails):
            return just(ProxyVoterListResult.proxyVoterSelected(proxyVoterDetails: proxyVoterDetails))
        case .proxyInformationSelected(let proxyVoterDetails):
            return just(ProxyVoterListResult.proxyInformationSelected(proxyVoterDetails: proxyVoterDetails))
        case .loadMoreProxyVoters(let lastAccount):
            return getMoreProxyVoters(nextAccount: lastAccount)
        }
    }

    override func reducer(previousState: ProxyVoterListViewState, result: ProxyVoterListResult) -> ProxyVoterListViewState {
        switch result {
        case .idle:
            return ProxyVoterListViewState.idle
        case .onProgress:
            return ProxyVoterListViewState.onProgress
        case .onError:
            return ProxyVoterListViewState.onError
        case .onSuccess(let proxyVoterDetails):
            return ProxyVoterListViewState.onSuccess(proxyVoterDetails: proxyVoterDetails)
        case .onMoreError:
            return ProxyVoterListViewState.onMoreError
        case .onMoreProgress:
            return ProxyVoterListViewState.onMoreProgress
        case .onMoreSuccess(let proxyVoterDetails):
            return ProxyVoterListViewState.onMoreSuccess(proxyVoterDetails: proxyVoterDetails)
        case .proxyInformationSelected(let proxyVoterDetails):
            return ProxyVoterListViewState.proxyInformationSelected(proxyVoterDetails: proxyVoterDetails)
        case .proxyVoterSelected(let proxyVoterDetails):
            return ProxyVoterListViewState.proxyVoterSelected(proxyVoterDetails: proxyVoterDetails)
        }
    }
    
    private func getProxyVoters() -> Observable<ProxyVoterListResult> {
        return proxyVoterRequest.getProxyVoters(nextAccount: "").map { result in
            if (result.success()) {
                return ProxyVoterListResult.onSuccess(proxyVoterDetails: result.data!)
            } else {
                return ProxyVoterListResult.onError
            }
        }.catchErrorJustReturn(ProxyVoterListResult.onError)
            .asObservable()
            .startWith(ProxyVoterListResult.onProgress)
    }
    
    private func getMoreProxyVoters(nextAccount: String) -> Observable<ProxyVoterListResult> {
        return proxyVoterRequest.getProxyVoters(nextAccount: nextAccount).map { result in
            if (result.success()) {
                return ProxyVoterListResult.onSuccess(proxyVoterDetails: result.data!)
            } else {
                return ProxyVoterListResult.onMoreError
            }
        }.catchErrorJustReturn(ProxyVoterListResult.onMoreError)
            .asObservable()
            .startWith(ProxyVoterListResult.onMoreProgress)
    }
}
