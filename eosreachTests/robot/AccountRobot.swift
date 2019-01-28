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
    
    func verifyAccountError() {
        // account_error_container
        // error_view
        // error_view_title
        // error_view_body
        // error_view_retry
    }
    
    func selectAccountErrorRetry() {
        
    }
    
    func selectResourcesTab() {
        onView(withText("Resources"))
            .matchesNext(isDisplayed())
            .perform(click())
    }
}
