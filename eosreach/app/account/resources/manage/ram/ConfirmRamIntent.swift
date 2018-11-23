import Foundation

enum ConfirmRamIntent: MxIntent {
    case idle
    case start(ramBundle: RamBundle)
    case confirm(accountName: String, kb: String, commitType: RamBundle.CommitType)
}
