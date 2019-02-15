import Foundation
import UIKit

protocol BlockScope {
}
extension BlockScope {
    @inline(__always) func apply(block: (Self) -> ()) -> Self {
        block(self)
        return self
    }
    @inline(__always) func with<R>(_ block: (Self) -> R) -> R {
        return block(self)
    }
}

extension NSObject: BlockScope {
}

extension UIView: BlockScope {
}

extension Array {
    func isNotEmpty() -> Bool {
        return self.count > 0
    }
}

extension String {
    func isNotEmpty() -> Bool {
        return self.count > 0
    }
}
