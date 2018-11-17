import Foundation

protocol Scope {
}
extension Scope {
    @inline(__always) func apply(block: (Self) -> ()) -> Self {
        block(self)
        return self
    }
    @inline(__always) func with<R>(block: (Self) -> R) -> R {
        return block(self)
    }
}

extension NSObject: Scope {
}
