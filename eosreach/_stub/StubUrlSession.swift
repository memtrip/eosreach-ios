import Foundation
import eosswift

class StubUrlSession {
        
    static let shared = StubUrlSession()
    
    let urlSession: URLSession
    
    var stubApi: StubApi = StubApi()
    
    init() {
        urlSession = URLSession(configuration: URLSessionConfiguration.default.with(block: { it in 
            it.protocolClasses = [
                StubUrlProtocol.self
            ]
            return it
        }))
    }
    
    func stubConnection() -> StubConnection {
        return StubConnection(stubs: stubApi.stubs())
    }
}

class StubUrlProtocol : URLProtocol {
    
    override open class func canInit(with request: URLRequest) -> Bool {
        let hasMatch = StubUrlSession.shared.stubConnection().hasMatch(request: request)
        if (hasMatch) {
            return true
        } else {
            fatalError("Could not match on URLRequest: \(request)")
        }
    }
    
    override func startLoading() {
    
        let urlResponse = StubUrlSession.shared.stubConnection().performRequest(request: request)
        
        if (urlResponse.response.success()) {
            client?.urlProtocol(self, didReceive: urlResponse.response, cacheStoragePolicy: .allowed)
            if let body = urlResponse.responseBody {
                client?.urlProtocol(self, didLoad: body)
            }
        } else {
            client?.urlProtocol(self, didFailWithError: StubError())
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override open func stopLoading() {
    }
    
    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
}

class StubError : Error {
}
