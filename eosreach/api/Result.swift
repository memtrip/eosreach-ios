import Foundation

struct Result<T, E : ApiError> {
    let data: T?
    let error: E?

    func success() -> Bool {
        return data != nil
    }
}

protocol ApiError {
}
