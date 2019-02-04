import Foundation

class AccountRobot : Robot {
 
    func verifyAccountScreen() {
        onView(withId("account_toolbar"))
            .matches(isDisplayed())
        
        onView(withId("account_balances"))
            .matches(isDisplayed())
    }
    
    func verifyAvailableBalance(availableBalance: String) {
        onView(withId("account_available_balance_value"))
            .matchesNext(isDisplayed())
            .matches(withText(availableBalance))
        
        onView(withId("account_available_balance_label"))
            .matchesNext(isDisplayed())
            .matches(withText("Available Balance"))
    }
    
    func verifyUnavailableBalance() {
        onView(withId("account_available_balance_value"))
            .matchesNext(isDisplayed())
            .matches(withText("-"))
        
        onView(withId("account_available_balance_label"))
            .matchesNext(isDisplayed())
            .matches(withText("unavailable"))
        
    }
    
    func selectResourcesTab() {
        onView(withText("Resources"))
            .matchesNext(isDisplayed())
            .perform(click())
    }
    
    func selectVoteTab() {
        onView(withText("Vote"))
            .matchesNext(isDisplayed())
            .perform(click())
    }
}
