import Foundation

enum ProxyVoterListIntent: MxIntent {
    case idle
    case start
    case retry
    case proxyVoterSelected(proxyVoterDetails: ProxyVoterDetails)
    case proxyInformationSelected(proxyVoterDetails: ProxyVoterDetails)
    case loadMoreProxyVoters(lastAccount: String)
}
