import Foundation
import UIKit
@testable import stub

class StubTestCase : TestCase {
    
    override func setUp() {
        StoreKitStubStateHolder.shared.state = StoreKitStubState.success
        StubUrlSession.shared.stubApi = configure(stubApi: StubApi())
        (UIApplication.shared.delegate as! AppDelegate).clearData()
        (UIApplication.shared.delegate as! AppDelegate).resetApplicationState()
    }
    
    func configure(stubApi: StubApi) -> StubApi {
        return stubApi
    }
}
