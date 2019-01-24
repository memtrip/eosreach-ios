import XCTest
import EarlGrey

class FirstTest: XCTestCase {
    
    func testExample() {
        EarlGrey.selectElement(with: grey_keyWindow())
            .assert(grey_sufficientlyVisible())
    }
}
