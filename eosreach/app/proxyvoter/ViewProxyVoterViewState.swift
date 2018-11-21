import Foundation

enum ViewProxyVoterViewState: MxViewState {
    case idle
    case onProgress
    case onError
    case populate(proxyVoterDetails: ProxyVoterDetails)
    case onInvalidUrl(url: String)
    case navigateToUrl(url: String)
}
