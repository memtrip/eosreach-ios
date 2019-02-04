import Foundation
import eosswift

class StubUrlSession {
    
    static let shared = StubUrlSession()
    
    let urlSession: URLSession
    
    var stubApi: StubApi = StubApi()
    
    private var internalState: Int = 0
    private let internalQueue: DispatchQueue = DispatchQueue(label:"LockingQueue")
    
    init() {
        urlSession = URLSession(configuration: URLSessionConfiguration.default.with({ it in 
            it.protocolClasses = [
                StubUrlProtocol.self
            ]
            return it
        }))
    }
}

class StubUrlProtocol : URLProtocol {
    
    override open class func canInit(with request: URLRequest) -> Bool {
        if (StubConnection.hasMatch(
            request: request,
            stubApi: StubUrlSession.shared.stubApi
        )) {
            return true
        } else {
            fatalError("Could not match on URLRequest: \(request)")
        }
    }
    
    override func startLoading() {
    
        let urlResponse = StubConnection.performRequest(
            request: request,
            stubApi: StubUrlSession.shared.stubApi)
        
        client?.urlProtocol(self, didReceive: urlResponse.response, cacheStoragePolicy: .allowed)
        if let body = urlResponse.responseBody {
            client?.urlProtocol(self, didLoad: body)
        }

        client?.urlProtocolDidFinishLoading(self)
    }
    
    override open func stopLoading() {
    }
    
    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
}
