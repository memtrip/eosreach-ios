import Foundation
@testable import stub

class VerifyReadOnlySearchAccountTestCase : TestCase {
    
    func testVerifyReadOnlySearchAccount() {
        splashRobot.selectExplore()
        
        searchRobot.begin { it in
            it.verifySearchScreen()
            it.typeAccountName(accountName: "memtripissue")
            it.selectAccount()
        }
        
        accountRobot.begin { it in
            it.verifyReadOnlyAccountScreen()
            it.verifyAvailableBalance(availableBalance: "$162947.12")
            it.selectVoteTab()
        }
    }
}
