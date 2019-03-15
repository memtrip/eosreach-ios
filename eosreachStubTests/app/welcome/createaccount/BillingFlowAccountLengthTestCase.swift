import Foundation
@testable import stub

class BillingFlowAccountLengthTestCase : TestCase {
    
    func testBillingFlowAccountLength() {
        splashRobot.selectCreateAccount()
        
        createAccountRobot.begin { it in
            it.verifyEnterAccountNameScreen()
            it.typeAccountName(accountName: "hello")
            it.verifyAccountMustStartWithLetterError()
        }
    }
}
