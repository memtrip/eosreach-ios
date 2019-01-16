import Foundation
import eosswift

class StubUrlProtocol : URLProtocol {
    
    override open class func canInit(with request: URLRequest) -> Bool {
        // return false if the request cannot be matched with a stub
        return true
    }
    
    override func startLoading() {
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

class MockUrlSession {
    
    static func urlSession() -> URLSession {
        return URLSession(configuration: configuration())
    }
    
    static func configuration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        
        configuration.protocolClasses = [
            StubUrlProtocol.self
        ]
        
        return configuration
    }
}
