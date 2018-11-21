import Foundation
import RxSwift

class ViewProxyVoterViewModel: MxViewModel<ViewProxyVoterIntent, ViewProxyVoterResult, ViewProxyVoterViewState> {

    private let proxyVoterRequest = ProxyVoterRequestImpl()
    
    override func dispatcher(intent: ViewProxyVoterIntent) -> Observable<ViewProxyVoterResult> {
        switch intent {
        case .idle:
            return just(ViewProxyVoterResult.idle)
        case .start(let viewProxyVoterBundle):
            return start(viewProxyVoterBundle: viewProxyVoterBundle)
        case .retry(let viewProxyVoterBundle):
            return start(viewProxyVoterBundle: viewProxyVoterBundle)
        case .navigateToUrl(let url):
            return just(validUrl(url: url))
        }
    }

    override func reducer(previousState: ViewProxyVoterViewState, result: ViewProxyVoterResult) -> ViewProxyVoterViewState {
        switch result {
        case .idle:
            return ViewProxyVoterViewState.idle
        case .onProgress:
            return ViewProxyVoterViewState.onProgress
        case .onError:
            return ViewProxyVoterViewState.onError
        case .populate(let proxyVoterDetails):
            return ViewProxyVoterViewState.populate(proxyVoterDetails: proxyVoterDetails)
        case .onInvalidUrl(let url):
            return ViewProxyVoterViewState.onInvalidUrl(url: url)
        case .navigateToUrl(let url):
            return ViewProxyVoterViewState.navigateToUrl(url: url)
        }
    }
    
    private func start(viewProxyVoterBundle: ViewProxyVoterBundle) -> Observable<ViewProxyVoterResult> {
        if (viewProxyVoterBundle.proxyVoterDetails != nil) {
            return just(ViewProxyVoterResult.populate(proxyVoterDetails: viewProxyVoterBundle.proxyVoterDetails!))
        } else {
            return getProxyVoterByAccountName(accountName: viewProxyVoterBundle.accountName!)
        }
    }
    
    private func validUrl(url: String) -> ViewProxyVoterResult {
        if (checkUrl(url: url)) {
            return ViewProxyVoterResult.navigateToUrl(url: url)
        } else {
            return ViewProxyVoterResult.onInvalidUrl(url: url)
        }
    }
    
    private func checkUrl(url: String) -> Bool {
        let url = URL.init(string: url)
        return url != nil
    }
    
    private func getProxyVoterByAccountName(accountName: String) -> Observable<ViewProxyVoterResult> {
        return proxyVoterRequest.getProxy(accountName: accountName).map { result in
            if (result.success()) {
                return ViewProxyVoterResult.populate(proxyVoterDetails: result.data!)
            } else {
                return ViewProxyVoterResult.onError
            }
        }.asObservable().startWith(ViewProxyVoterResult.onProgress)
    }
}
