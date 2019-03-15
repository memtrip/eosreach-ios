import Foundation
@testable import stub

class BillingFlowCannotMakePaymentErrorTestCase : TestCase {
    
    func testBillingFlowCannotMakePaymentErrorTestCase() {
         splashRobot.selectCreateAccount()
        
        createAccountRobot.begin { it in
            it.verifyEnterAccountNameScreen()
            it.typeAccountName(accountName: "memtripissue")
            it.verifyCannotMakePaymentError()
        }
    }
    
    override func configure(stubApi: StubApi) -> StubApi {
        StoreKitStubStateHolder.shared.state = StoreKitStubState.cannotMakePayment
        return stubApi
    }
}
