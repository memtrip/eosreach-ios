import Foundation
import XCTest
@testable import stub

class TestCase : XCTestCase {
    
    override func setUp() {
        StubUrlSession.shared.stubApi = configure(stubApi: StubApi())
    }
    
    func configure(stubApi: StubApi) -> StubApi {
        return stubApi
    }
}
