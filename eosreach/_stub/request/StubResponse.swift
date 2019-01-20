import Foundation

struct StubResponse {
    let response: HTTPURLResponse
    let responseBody: Data?
}

extension HTTPURLResponse {
    
    func success() -> Bool {
        return statusCode >= 200 && statusCode < 300
    }
    
    func failed() -> Bool {
        return !success()
    }
}
