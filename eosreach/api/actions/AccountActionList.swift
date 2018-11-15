import Foundation

struct AccountActionList {
    let actions: [AccountAction]
    let noResultsNext: Int

    init(actions: [AccountAction], noResultsNext: Int = -1) {
        self.actions = actions
        self.noResultsNext = noResultsNext
    }
}
