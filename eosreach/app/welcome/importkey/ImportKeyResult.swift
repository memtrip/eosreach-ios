import Foundation

enum ImportKeyResult: MxResult {
    case idle
    case onProgress
    case onSuccess
    case onError(error: String)
    case navigateToGithubSource
    case navigateToSettings
}
