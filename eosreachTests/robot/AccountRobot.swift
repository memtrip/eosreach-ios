import Foundation

class AccountRobot : Robot {
 
    func verifyAccountScreen() {
        onView(withId("account_toolbar"))
            .matches(isDisplayed())
        
        onView(withId("account_balances"))
            .matches(isDisplayed())
        
        onView(withId("account_menu_item"))
            .matches(isDisplayed())
        
        onView(withId("account_search_item"))
            .matches(isDisplayed())
    }
    
    func verifyReadOnlyAccountScreen() {

        onView(withId("account_toolbar"))
            .matches(isDisplayed())

        onView(withId("account_balances"))
            .matches(isDisplayed())
        
        onView(withId("account_menu_item"))
            .matches(not(isDisplayed()))
        
        onView(withId("account_search_item"))
            .matches(not(isDisplayed()))
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
    
    func selectMenu() {
        onView(withId("account_menu_item"))
            .matchesNext(isDisplayed())
            .perform(click())
    }
    
    func selectMenuImportKey() {
        onView(withId("account_navigation_import_key_button"))
            .matchesNext(isDisplayed())
            .perform(click())
    }
    
    func selectMenuSettings() {
        onView(withId("account_navigation_settings_button"))
            .matchesNext(isDisplayed())
            .perform(click())
    }
}
