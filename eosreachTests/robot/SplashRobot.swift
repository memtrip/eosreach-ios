import Foundation

class SplashRobot: Robot {

    func selectCreateAccount() {
        onView(withId("welcome_splash_create_account_button"))
            .matchesNext(isDisplayed())
            .perform(click())
    }
    
    func selectImportKey() {
        onView(withId("welcome_splash_import_private_key_button"))
            .matchesNext(isDisplayed())
            .perform(click())
    }
    
    func selectExplore() {
        onView(withId("welcome_splash_explore_button"))
            .matchesNext(isDisplayed())
            .perform(click())
    }
}

