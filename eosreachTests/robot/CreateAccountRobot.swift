import Foundation

class CreateAccountRobot : Robot {
    
    func verifyEnterAccountNameScreen() {
        onView(withId("create_account_toolbar"))
            .matches(isDisplayed())
        
        onView(withId("create_account_form"))
            .matches(isDisplayed())
        
        onView(
            withIdInParent(withId("create_account_form"), id: "create_account_name_input")
        ).matches(isDisplayed())
        
        onView(
            withIdInParent(withId("create_account_form"), id: "create_account_instruction_label")
        ).matches(isDisplayed())
        
        onView(
            withIdInParent(withId("create_account_form"), id: "create_account_resource_instruction_label")
        ).matches(isDisplayed())
        
        onView(
            withIdInParent(withId("create_account_form"), id: "create_account_form_cta")
        ).matches(isDisplayed())
    }
    
    func typeAccountName(accountName: String) {
        
        onView(
            withIdInParent(withId("create_account_form"), id: "create_account_name_input")
        ).matchesNext(isDisplayed()).perform(replaceText(accountName))
    }
    
    func selectCreateAccountButton() {
        
        onView(
            withIdInParent(withId("create_account_form"), id: "create_account_form_cta")
        ).matchesNext(isDisplayed()).perform(click())
    }
    
    func verifyAccountCreatedScreen() {
        
        onView(withId("create_account_done"))
            .matches(isDisplayed())
        
        onView(
            withIdInParent(withId("create_account_done"), id: "create_account_done_title_label")
        ).matches(isDisplayed())
        
        onView(
            withIdInParent(withId("create_account_done"), id: "create_account_done_instruction_label")
        ).matches(isDisplayed())
        
        onView(
            withIdInParent(withId("create_account_done"), id: "create_account_done_privatekey_label")
        ).matches(isDisplayed())
        
        onView(
            withIdInParent(withId("create_account_done"), id: "create_account_done_button")
        ).matches(isDisplayed())
    }
    
    func verifyCreateAccountError() {
        onView(allOf(withText("Sorry"), isDisplayed()))
            .matches(isDisplayed())
        
        onView(allOf(withText("We could not create an account at this time, please check your connection and try again."), isDisplayed()))
            .matches(isDisplayed())
        
        onView(allOf(withText("OK"), isDisplayed()))
            .matchesNext(isDisplayed())
            .perform(click())
    }
    
    func selectAccountCreatedDoneButton() {
        
        onView(
            withIdInParent(withId("create_account_done"), id: "create_account_done_button")
        ).matchesNext(isDisplayed()).perform(click())
    }
    
    func verifyLimboScreen() {
        
        onView(withIdInParent(
            withId("create_account_limbo_container"),
            id: "create_account_limbo_title"
        ))
            .matchesNext(isDisplayed())
            .matches(withText("Connectivity issue"))
        
        onView(withIdInParent(
            withId("create_account_limbo_container"),
            id: "create_account_limbo_body"
        ))
            .matchesNext(isDisplayed())
            .matches(withText("We could not create your account at this time. Please check your internet connection and try again. If this problem continues to persist, please change your EOS endpoint from settings."))
        
        onView(withIdInParent(
            withId("create_account_limbo_container"),
            id: "create_account_limbo_settings_button"
        )).matches(isDisplayed())
    }
    
    func verifyLimboScreenNotDisplayed() {
        
        onView(withIdInParent(
            withId("create_account_limbo_container"),
            id: "create_account_limbo_title"
        ))
            .matchesNext(not(isDisplayed()))
            .matches(withText("Connectivity issue"))
        
        onView(withIdInParent(
            withId("create_account_limbo_container"),
            id: "create_account_limbo_body"
        ))
            .matchesNext(not(isDisplayed()))
            .matches(withText("We could not create your account at this time. Please check your internet connection and try again. If this problem continues to persist, please change your EOS endpoint from settings."))
        
        onView(withIdInParent(
            withId("create_account_limbo_container"),
            id: "create_account_limbo_settings_button"
        )).matches(not(isDisplayed()))
    }
    
    func selectLimboSettingsButton() {
        onView(withIdInParent(
            withId("create_account_limbo_container"),
            id: "create_account_limbo_settings_button"
        )).matchesNext(isDisplayed()).perform(click())
    }
    
    func selectLimboRetryButton() {
        onView(withIdInParent(
            withId("create_account_limbo_container"),
            id: "create_account_limbo_retry_button"
        )).matchesNext(isDisplayed()).perform(click())
    }
    
    func verifyCreateAccountUnavailable() {
        onView(withId("create_account_toolbar"))
            .matches(isDisplayed())
        
        onView(withId("create_account_sku_not_found"))
            .matches(isDisplayed())
    }
}
