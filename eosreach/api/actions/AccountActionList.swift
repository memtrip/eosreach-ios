import Foundation

struct AccountActionList {
    let actions: [AccountAction]
    let noResultsNext: Int64

    init(actions: [AccountAction], noResultsNext: Int64 = -1) {
        self.actions = actions
        self.noResultsNext = noResultsNext
    }
}
