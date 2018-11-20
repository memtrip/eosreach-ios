import Foundation

protocol AccountViewLayout {
    func populate(accountView: AccountView, page: AccountPage)
    func populateTitle(title: String)
    func showPriceUnavailable()
    func showPrice(formattedPrice: String)
    func showProgress()
    func showGetAccountError()
    func showGetBalancesError()
    func openNavigation()
    func navigateToExplore()
}
