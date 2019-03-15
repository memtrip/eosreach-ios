import Foundation
@testable import stub

class BillingFlowAccountNumericStartTestCase : TestCase {
    
    func testBillingFlowAccountNumericStart() {
        splashRobot.selectCreateAccount()
        
        createAccountRobot.begin { it in
            it.verifyEnterAccountNameScreen()
            it.typeAccountName(accountName: "1memtripissu")
            it.verifyAccountMustStartWithLetterError()
        }
    }
}
