import Foundation
@testable import stub

class BillingFlowPaymentFailedErrorTestCase : TestCase {
    
    func testBillingFlowPaymentFailedTestCase() {
        splashRobot.selectCreateAccount()
        
        createAccountRobot.begin { it in
            it.verifyEnterAccountNameScreen()
            it.typeAccountName(accountName: "memtripissue")
            it.verifyPaymentFailedError()
        }
    }
    
    override func configure(stubApi: StubApi) -> StubApi {
        StoreKitStubStateHolder.shared.state = StoreKitStubState.paymentFailed
        return stubApi
    }
}
