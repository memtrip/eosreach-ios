import Foundation
@testable import stub

class ProxyVoteTestCase : TestCase {
    
    func testProxyVote() {
        importKeyOrchestra
            .go(privateKey: "5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3")
        
        accountRobot.begin { it in
            it.verifyAccountScreen()
            it.verifyAvailableBalance(availableBalance: "$162947.12")
            it.selectVoteTab()
        }
        
        voteRobot
            .verifyProxyVoteScreen()
    }
    
    override func configure(stubApi: StubApi) -> StubApi {
        stubApi.getAccount = Stub(
            matcher: StubMatcher(
                rootUrl: R.string.appStrings.app_endpoint_url(),
                urlMatcher: regex("v1/chain/get_account$")
            ),
            request: BasicStubRequest(code: 200, body: {
                return readJson(R.file.happy_path_get_account_voter_info_proxy_voteJson())
            })
        )
        return stubApi
    }
}
