import Foundation

enum AccountNavigationIntent: MxIntent {
    case idle
    case start
    case accountSelected(accountName: AccountEntity)
    case refreshAccounts
}
