import Foundation

enum ConfirmRamIntent: MxIntent {
    case idle
    case start
    case confirm(accountName: String, kb: String, commitType: RamBundle.CommitType)
}
