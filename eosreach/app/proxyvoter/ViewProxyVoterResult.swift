import Foundation

enum ViewProxyVoterResult: MxResult {
    case idle
    case onProgress
    case onError
    case populate(proxyVoterDetails: ProxyVoterDetails)
    case onInvalidUrl(url: String)
    case navigateToUrl(url: String)
}
