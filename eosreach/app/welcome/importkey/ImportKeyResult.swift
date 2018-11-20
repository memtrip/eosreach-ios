import Foundation

enum ImportKeyResult: MxResult {
    case idle
    case onProgress
    case onSuccess
    case genericError
    case invalidKey
    case noAccounts
    case navigateToGithubSource
    case navigateToSettings
}
