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
        return hasMatch
    }
    
    override func startLoading() {
    
        let urlResponse = StubUrlSession.shared.stubConnection().performRequest(request: request)
        
        if (urlResponse.response.success()) {
            client?.urlProtocol(self, didReceive: urlResponse.response, cacheStoragePolicy: .allowed)
            client?.urlProtocolDidFinishLoading(self)
        } else {
            client?.urlProtocol(self, didFailWithError: StubError())
        }
        
        // FAILURE
        // client?.urlProtocol(self, didFailWithError: Mew())
        // SUCCESS
        // client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
        // client?.urlProtocolDidFinishLoading(self)
    }
    
    override open func stopLoading() {
        // potentially call this here:
        // client?.urlProtocolDidFinishLoading(self)
    }
    
    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
}

class StubError : Error {
}
