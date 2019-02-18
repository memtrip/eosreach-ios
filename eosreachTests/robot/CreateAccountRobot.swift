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
}
