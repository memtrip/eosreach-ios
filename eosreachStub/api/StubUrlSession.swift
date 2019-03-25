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

extension URLRequest {

    func streamToString() -> String? {
        var data = Data()
        var buffer = [UInt8](repeating: 0, count: 4096)
        
        if let stream = httpBodyStream {
            stream.open()
            while stream.hasBytesAvailable {
                let length = stream.read(&buffer, maxLength: 4096)
                if length == 0 {
                    break
                } else {
                    data.append(&buffer, count: length)
                }
            }
            stream.close()
            return String(data: data, encoding: .utf8)
        } else {
            return nil
        }
    }
}
