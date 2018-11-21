import Foundation

enum ViewProxyVoterIntent: MxIntent {
    case idle
    case start(viewProxyVoterBundle: ViewProxyVoterBundle)
    case retry(viewProxyVoterBundle: ViewProxyVoterBundle)
    case navigateToUrl(url: String)
}
