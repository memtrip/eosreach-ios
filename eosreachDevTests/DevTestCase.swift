import Foundation
import UIKit
@testable import dev

class DevTestCase : TestCase {
    
    override func setUp() {
        (UIApplication.shared.delegate as! AppDelegate).clearData()
        (UIApplication.shared.delegate as! AppDelegate).resetApplicationState()
    }
}
