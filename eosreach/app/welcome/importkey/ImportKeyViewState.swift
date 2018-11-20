import Foundation

enum ImportKeyViewState: MxViewState {
    case idle
    case onProgress
    case onSuccess
    case genericError
    case invalidKey
    case noAccounts
    case navigateToGithubSource
    case navigateToSettings
}
