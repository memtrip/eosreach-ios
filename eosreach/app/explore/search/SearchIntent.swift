import Foundation

enum SearchIntent: MxIntent {
    case idle
    case searchValueChanged(searchValue: String)
    case viewAccount(accountCardModel: AccountCardModel)
}
