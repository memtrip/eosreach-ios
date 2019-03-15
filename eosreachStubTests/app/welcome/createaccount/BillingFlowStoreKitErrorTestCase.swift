import Foundation
@testable import stub

class BillingFlowStoreKitErrorTestCase : StubTestCase {
    
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
