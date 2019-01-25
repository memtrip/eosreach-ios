import Foundation
@testable import stub

class SplashRobot {

    func selectCreateAccount() -> SplashRobot {
        onView(withId("welcome_splash_create_account_button"))
            .matches(isDisplayed())
            .perform(click())
        return self
    }
    
    func selectImportKey() -> SplashRobot {
        onView(withId("welcome_splash_import_private_key_button"))
            .matches(isDisplayed())
            .perform(click())
        return self
    }
    
    func selectExplore() -> SplashRobot {
        onView(withId("welcome_splash_explore_button"))
            .matches(isDisplayed())
            .perform(click())
        return self
    }
}

