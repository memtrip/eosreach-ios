import Foundation

protocol Robot {
}

extension Robot {
    @inline(__always) func begin(_ block: (Self) -> ()) -> Void {
        block(self)
    }
}
