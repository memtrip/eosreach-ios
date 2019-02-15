import Foundation

class SearchRobot : Robot {
    
    func verifySearchScreen() {
        
        onView(withId("explore_search_input_view"))
            .matches(isDisplayed())
    }
    
    func typeAccountName(accountName: String) {
        
        onView(withId("explore_search_input_view"))
            .matchesNext(isDisplayed())
            .perform(replaceText(accountName))
    }
    
    func selectAccount() {
        
        onView(withId("explore_search_account_card"))
            .matches(isDisplayed())
        
        onView(
            withIdInTableView("explore_search_account_card", position: 0, id: "account_card_border_view")
        )
            .matchesNext(isDisplayed())
            .perform(click())
    }
}
