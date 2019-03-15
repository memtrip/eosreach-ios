import Foundation
@testable import stub

class BillingFlowAccountLengthTestCase : StubTestCase {
    
    func testBillingFlowAccountLength() {
        splashRobot.selectCreateAccount()
        
        createAccountRobot.begin { it in
            it.verifyEnterAccountNameScreen()
            it.typeAccountName(accountName: "hello")
            it.verifyAccountMustStartWithLetterError()
        }
    }
}
