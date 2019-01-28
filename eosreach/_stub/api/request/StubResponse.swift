import Foundation

struct StubResponse: Scope {
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

extension URLRequest {
    
    func bodyString() -> String? {
        if let body = httpBody {
            return String(data: body, encoding: String.Encoding.utf8)
        } else {
            return nil
        }
    }
}
