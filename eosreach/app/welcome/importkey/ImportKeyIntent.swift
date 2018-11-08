import Foundation

enum ImportKeyIntent: MxIntent {
    case idle
    case importKey(privateKey: String)
    case viewSource
    case navigateToSettings
}
