import Foundation

enum ImportKeyViewState: MxViewState {
    case idle
    case onProgress
    case onSuccess
    case onError(error: String)
    case navigateToGithubSource
    case navigateToSettings
}
