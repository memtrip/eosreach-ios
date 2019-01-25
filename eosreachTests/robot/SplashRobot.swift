import Foundation
@testable import stub

class SplashRobot: Robot {

    func selectCreateAccount() {
        onView(withId("welcome_splash_create_account_button"))
            .matches(isDisplayed())
            .perform(click())
    }
    
    func selectImportKey() {
        onView(withId("welcome_splash_import_private_key_button"))
            .matches(isDisplayed())
            .perform(click())
    }
    
    func selectExplore() {
        onView(withId("welcome_splash_explore_button"))
            .matches(isDisplayed())
            .perform(click())
    }
}

