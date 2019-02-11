import Foundation
@testable import stub

class VoteForProxyTestCase : TestCase {
    
    func testVoteForProxy() {
        
        importKeyOrchestra
            .go(privateKey: "5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3")
        
        accountRobot.begin { it in
            it.verifyAccountScreen()
            it.verifyAvailableBalance(availableBalance: "$162947.12")
            it.selectVoteTab()
        }
        
        voteRobot.begin { it in
            it.verifyNotVotedScreen()
            it.selectVoteForProxy()
            it.verifyCastProxyVoteScreen()
            it.typeCastProxyVote(proxyName: "memtripproxy")
        }
        
        transactionRobot
            .verifyTransactionLogScreen()
        
        commonRobot
            .selectToolbarBackButton()
        
        voteRobot.selectCastProxyVoteButton()
        
        accountRobot.begin { it in
            it.verifyAccountScreen()
            it.verifyAvailableBalance(availableBalance: "$162947.12")
        }
        
        voteRobot.begin { it in
            it.verifyNotVotedScreen()
        }
    }
    
    override func configure(stubApi: StubApi) -> StubApi {
    
        let request = QueuedStubRequest(requests: LinkedList<StubRequest>().apply { it in
            it.append(BasicStubRequest(
                code: 400,
                body: {
                    readJson(R.file.error_push_transaction_logJson())
                }
            ))
            it.append(BasicStubRequest(
                code: 200,
                body: {
                    readJson(R.file.happy_path_push_transaction_logJson())
                }
            ))
        })
        
        stubApi.pushTransaction = Stub(
            matcher: StubMatcher(
                rootUrl: R.string.appStrings.app_endpoint_url(),
                urlMatcher: regex("v1/chain/push_transaction$")
            ),
            request: request
        )
        
        return stubApi
    }
}
