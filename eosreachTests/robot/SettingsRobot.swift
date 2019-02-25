import Foundation

class SettingsRobot : Robot {
    
    func verifySettingsScreen() {
        onView(withId("search_toolbar"))
            .matches(isDisplayed())
        
        onView(withId("search_currency_pair_button"))
            .matches(isDisplayed())
        
        onView(withId("search_change_endpoint_button"))
            .matches(isDisplayed())
        
        onView(withId("search_view_private_keys_button"))
            .matches(isDisplayed())
        
        onView(withId("search_join_us_on_telegram_button"))
            .matches(isDisplayed())
        
        onView(withId("search_confirmed_transaction_button"))
            .matches(isDisplayed())
        
        onView(withId("search_clear_data_and_logout_button"))
            .matches(isDisplayed())
        
        onView(withId("search_memtrip_button"))
            .matches(isDisplayed())
    }
    
    func selectClearDataAndLogout() {
        onView(withId("search_clear_data_and_logout_button"))
            .matchesNext(isDisplayed())
            .perform(click())
    }
}
