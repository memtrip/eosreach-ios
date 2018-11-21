import Foundation

protocol AccountNavigationDelegate {
    func importKeyNavigationSelected()
    func createAccountNavigationSelected()
    func settingsNavigationSelected()
    func accountsNavigationSelected(accountName: String)
}
