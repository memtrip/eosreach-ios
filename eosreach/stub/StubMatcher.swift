import Foundation

struct StubMatcher {
    let rootUrl: String
    let urlMatcher: NSRegularExpression
    let bodyMatcher: String? = nil
}
