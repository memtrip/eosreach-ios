import Foundation

class ErrorOnFirstStubRequest : StubRequest {
    
    private let code: Int
    private let body: () -> Data?
    private let headers: [String : String]
    
    init(code: Int, body: @escaping () -> Data?, headers: [String : String] = [:]) {
        self.code = code
        self.body = body
        self.headers = headers
    }
    
    private lazy var requests: LinkedList<StubRequest> = {
        let linkedList = LinkedList<StubRequest>()
        linkedList.append(BasicStubRequest(code: 400))
        return linkedList
    }()
    
    func call(request: URLRequest) -> StubResponse {
        return requests.remove(at: 0).call(request: request).with { it in
            requests.append(BasicStubRequest(
                code: self.code,
                body: self.body,
                headers: self.headers
            ))
            return it
        }
    }
}
