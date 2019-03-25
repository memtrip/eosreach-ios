import Foundation

class QueuedStubRequest : StubRequest {
    
    private let requests: LinkedList<StubRequest>
    
    init(requests: LinkedList<StubRequest>) {
        self.requests = requests
    }
    
    func call(request: URLRequest) -> StubResponse {
        return requests.remove(at: 0).call(request: request)
    }
}
