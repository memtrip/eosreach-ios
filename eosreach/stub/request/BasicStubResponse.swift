import Foundation

class BasicStubRequest : StubRequest {

    private let code: Int
    private let body: () -> Data?
    private let headers: [String : String]?
    
    init(code: Int, body: @escaping () -> Data?, headers: [String : String] = [:]) {
        self.code = code
        self.body = body
        self.headers = headers
    }
    
    func call(request: URLRequest) -> StubResponse {
        return StubResponse(
            response: HTTPURLResponse(
                url: request.url!,
                statusCode: code,
                httpVersion: nil,
                headerFields: headers)!,
            responseBody: body()
        )
    }
}
