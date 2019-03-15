import Foundation
@testable import stub

class BlockProducerVoteTestCase : TestCase {
    
    func testBlockProducerVote() {
        importKeyOrchestra
            .go(privateKey: "5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3")
        
        accountRobot.begin { it in
            it.verifyAccountScreen()
            it.verifyAvailableBalance(availableBalance: "$162947.12")
            it.selectVoteTab()
        }
        
        voteRobot
            .verifyVotedBlockProducersScreen()
    }
    
    override func configure(stubApi: StubApi) -> StubApi {
        stubApi.getAccount = Stub(
            matcher: StubMatcher(
                rootUrl: R.string.appStrings.app_endpoint_url(),
                urlMatcher: regex("v1/chain/get_account$")
            ),
            request: BasicStubRequest(code: 200, body: {
                return readJson(R.file.happy_path_get_account_voter_info_producer_voteJson())
            })
        )
        return stubApi
    }
}
