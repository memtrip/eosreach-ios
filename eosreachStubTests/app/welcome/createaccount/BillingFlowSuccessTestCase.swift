import Foundation
@testable import stub

class BillingFlowSuccessTestCase : TestCase {

    func testBillingFlowSuccess() {
        splashRobot.selectCreateAccount()
        
        createAccountRobot.begin { it in
            it.verifyEnterAccountNameScreen()
            it.typeAccountName(accountName: "memtripissue")
            it.verifyAccountCreatedScreen()
            it.selectAccountCreatedDoneButton()
        }
        
        accountRobot.verifyAccountScreen()
    }
}
