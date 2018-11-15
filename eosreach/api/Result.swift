import Foundation

struct Result<T, E : ApiError> {
    let data: T?
    let error: E?

    func success() -> Bool {
        return data != nil
    }

    init(error: E?) {
        self.error = error
        self.data = nil
    }

    init(data: T?) {
        self.data = data
        self.error = nil
    }
}

protocol ApiError {
}
