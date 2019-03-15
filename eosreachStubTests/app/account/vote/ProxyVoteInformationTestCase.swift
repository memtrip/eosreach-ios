import Foundation
@testable import stub

class ProxyVoteInformationTestCase : StubTestCase {

    func testProxyVoteInformation() {
        
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
            it.selectExploreProxyAccountsButton()
        }
        
        proxyRobot.begin { it in
            it.verifyExploreProxyAccounts()
            it.selectFirstProxyInformationRow()
            it.verifyProxyInformation()
            it.selectViewAccount()
        }
        
        accountRobot.begin { it in
            it.verifyReadOnlyAccountScreen()
            it.verifyAvailableBalance(availableBalance: "$162947.12")
        }
    }
}
