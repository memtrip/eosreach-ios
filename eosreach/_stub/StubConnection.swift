import Foundation

class StubConnection {
    
    private let stubs: Array<Stub>
    
    init(stubs: Array<Stub>) {
        self.stubs = stubs
    }
    
    func performRequest(request: URLRequest) -> StubResponse {
        return self.match(request: request)!.request.call(request: request)
    }
    
    func hasMatch(request: URLRequest) -> Bool {
        return self.match(request: request) != nil
    }
    
    private func match(request: URLRequest) -> Stub? {
        let urlToMatch = request.url!.absoluteString
        return self.stubs.first(where: { stub in
            let urlMatch = stub.matcher.urlMatcher
                
            let matchedUrl = urlMatch.matches(
                in: urlToMatch,
                options: NSRegularExpression.MatchingOptions.anchored,
                range: NSRange(0..<urlToMatch.count)).count > 0
            
            return matchedUrl
        })
    }
}
