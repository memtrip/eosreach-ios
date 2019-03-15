import Foundation
@testable import stub

class NotVotedTestCase : StubTestCase {
    
    func testVoteForUsError() {
        importKeyOrchestra
            .go(privateKey: "5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3")
        
        accountRobot.begin { it in
            it.verifyAccountScreen()
            it.verifyAvailableBalance(availableBalance: "$162947.12")
            it.selectVoteTab()
        }
        
        voteRobot.begin { it in
            it.verifyNotVotedScreen()
            it.selectVoteForUs()
        }
        
        transactionRobot
            .verifyTransactionLogScreen()
        commonRobot
            .selectToolbarBackButton()
        voteRobot
            .verifyNotVotedScreen()
    }
}
