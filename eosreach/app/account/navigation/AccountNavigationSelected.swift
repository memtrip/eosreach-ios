import Foundation

enum AccountNavigationSelected {
    case importKey
    case createAccount
    case settings
    case selectAccount(accountName: String)
}
