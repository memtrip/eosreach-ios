import Foundation
@testable import stub

class BillingFlowStoreKitErrorTestCase : TestCase {
    
    func testBillingFlowStoreKitError() {
        splashRobot.selectCreateAccount()
        
        createAccountRobot.begin { it in
            it.verifyCreateAccountUnavailable()
        }
    }
    
    override func configure(stubApi: StubApi) -> StubApi {
        StoreKitStubStateHolder.shared.state = StoreKitStubState.storekitError
        return stubApi
    }
}
