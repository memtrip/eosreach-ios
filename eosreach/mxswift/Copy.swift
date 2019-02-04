import Foundation

protocol Copy {
}

extension Copy {
    func copy(_ copy: (inout Self) -> Void) -> Self {
        var value = self
        copy(&value)
        return value
    }
}
