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
            .matches(not(isDisplayed()))
        
        onView(withIdInParent(
            withId("create_account_limbo_container"),
            id: "create_account_limbo_body"
        ))
            .matches(not(isDisplayed()))
        
        onView(withIdInParent(
            withId("create_account_limbo_container"),
            id: "create_account_limbo_settings_button"
        )).matches(not(isDisplayed()))
    }
    
    func verifyImportKeyErrorScreen() {
        
        onView(withIdInParent(
            withId("create_account_import_key_container"),
            id: "create_account_import_key_instruction_label"
        ))
            .matchesNext(isDisplayed())
            .matches(withText("Your account has been created, but we failed to sync your accounts. Please check your connection and try again. If this error still persists, please change your EOS endpoint in Settings."))
        
        onView(withIdInParent(
            withId("create_account_import_key_container"),
            id: "create_account_import_key_sync_button"
        ))
            .matches(isDisplayed())
        
        onView(withIdInParent(
            withId("create_account_import_key_container"),
            id: "create_account_import_key_settings_button"
        ))
            .matches(isDisplayed())
    }
    
    func verifyImportKeyErrorScreenNotDisplayed() {
        
        onView(withIdInParent(
            withId("create_account_import_key_container"),
            id: "create_account_import_key_instruction_label"
        )).matches(not(isDisplayed()))
        
        onView(withIdInParent(
            withId("create_account_import_key_container"),
            id: "create_account_import_key_sync_button"
        )).matches(not(isDisplayed()))
        
        onView(withIdInParent(
            withId("create_account_import_key_container"),
            id: "create_account_import_key_settings_button"
        )).matches(not(isDisplayed()))
    }
    
    func selectImportKeySettingsButton() {
        onView(withIdInParent(
            withId("create_account_import_key_container"),
            id: "create_account_import_key_settings_button"
        )).matchesNext(isDisplayed()).perform(click())
    }
    
    func selectImportKeySyncButton() {
        onView(withIdInParent(
            withId("create_account_import_key_container"),
            id: "create_account_import_key_sync_button"
        )).matchesNext(isDisplayed()).perform(click())
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
    
    func verifyAccountMustStartWithLetterError() {
        onView(allOf(withText("Sorry"), isDisplayed()))
            .matches(isDisplayed())
        
        onView(allOf(withText("Please enter an account name that is 12 characters in length."), isDisplayed()))
            .matches(isDisplayed())
        
        onView(allOf(withText("OK"), isDisplayed()))
            .matchesNext(isDisplayed())
            .perform(click())
    }
    
    func verifyAccountMustBe12CharactersError() {
        onView(allOf(withText("Sorry"), isDisplayed()))
            .matches(isDisplayed())
        
        onView(allOf(withText("Please use a-z for the first character of your account name."), isDisplayed()))
            .matches(isDisplayed())
        
        onView(allOf(withText("OK"), isDisplayed()))
            .matchesNext(isDisplayed())
            .perform(click())
    }
    
    func verifyCreateAccountUnavailable() {
        onView(withId("create_account_toolbar"))
            .matches(isDisplayed())
        
        onView(withId("create_account_sku_not_found"))
            .matches(isDisplayed())
    }
    
    func verifyCannotMakePaymentError() {
        onView(allOf(withText("Sorry"), isDisplayed()))
            .matches(isDisplayed())
        
        onView(allOf(withText("You cancelled the App Store purchase. You can import an existing private key if you do not want to pay our fee."), isDisplayed()))
            .matches(isDisplayed())
        
        onView(allOf(withText("OK"), isDisplayed()))
            .matchesNext(isDisplayed())
            .perform(click())
    }
    
    func verifyPaymentFailedError() {
        onView(allOf(withText("Sorry"), isDisplayed()))
            .matches(isDisplayed())
        
        onView(allOf(withText("App Store could not process your payment, please check your internet connection and try again. You have not been charged for this transaction."), isDisplayed()))
            .matches(isDisplayed())
        
        onView(allOf(withText("OK"), isDisplayed()))
            .matchesNext(isDisplayed())
            .perform(click())
    }
}
