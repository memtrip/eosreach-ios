import Foundation

struct StubMatcher {
    let rootUrl: String
    let urlMatcher: NSRegularExpression
    let bodyMatcher: String?
    
    init(rootUrl: String, urlMatcher: NSRegularExpression) {
        self.rootUrl = rootUrl
        self.urlMatcher = urlMatcher
        self.bodyMatcher = nil
    }
    
    init(rootUrl: String, urlMatcher: NSRegularExpression, bodyMatcher: String) {
        self.rootUrl = rootUrl
        self.urlMatcher = urlMatcher
        self.bodyMatcher = bodyMatcher
    }
}
