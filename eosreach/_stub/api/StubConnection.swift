import Foundation

class StubConnection {

    static func performRequest(request: URLRequest, stubApi: StubApi) -> StubResponse {
        return self.match(request: request, stubs: stubApi.stubs())!.request.call(request: request)
    }
    
    static func hasMatch(request: URLRequest, stubApi: StubApi) -> Bool {
        return self.match(request: request, stubs: stubApi.stubs()) != nil
    }
    
    private static func match(request: URLRequest, stubs: Array<Stub>) -> Stub? {
        let urlToMatch = request.url!.absoluteString
        return stubs.first(where: { stub in
            
            let urlMatch = stub.matcher.urlMatcher.matches(
                in: urlToMatch,
                range: NSRange(0..<urlToMatch.count)).count > 0
            
            if let bodyMatcher = stub.matcher.bodyMatcher {
                if let requestBodyString = request.streamToString() {
                    let bodyMatch = bodyMatcher.trim() == requestBodyString.trim()
                    return urlMatch && bodyMatch
                } else {
                    return false
                }
            } else {
                return urlMatch
            }
        })
    }
    
    private static func compareBody(body1: String, body2: String) -> Bool {
        return body1.trimmingCharacters(in: .whitespacesAndNewlines) ==
            body2.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
