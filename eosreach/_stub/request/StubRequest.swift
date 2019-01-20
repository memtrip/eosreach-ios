import Foundation

protocol StubRequest {
    func call(request: URLRequest) -> StubResponse
}
