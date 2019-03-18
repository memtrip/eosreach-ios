import Foundation

class TransferRobot : Robot {
 
    func verifyTransferScreen() {
        
        onView(withId("transfer_toolbar"))
            .matches(isDisplayed())
        
        onView(withId("transfer_to_input"))
            .matches(isDisplayed())
        
        onView(withId("transfer_amount_input"))
            .matches(isDisplayed())
        
        onView(withId("transfer_memo_input"))
            .matches(isDisplayed())
    }
    
    func enterTo(value: String) {
        onView(withId("transfer_to_input"))
            .matchesNext(isDisplayed())
            .perform(replaceText(value))
    }
    
    func enterAmount(value: String) {
        onView(withId("transfer_amount_input"))
            .matchesNext(isDisplayed())
            .perform(replaceText(value))
    }
    
    func enterMemo(value: String) {
        onView(withId("transfer_memo_input"))
            .matchesNext(isDisplayed())
            .perform(replaceText(value))
    }
    
    func pressNextButton() {
        onView(withId("transfer_next_button"))
            .matchesNext(isDisplayed())
            .perform(click())
    }
    
    func verifyTransferConfirmScreen() {
        onView(withId("transfer_confirm_toolbar"))
            .matches(isDisplayed())
        
        onView(withId("transfer_confirm_amount_value"))
            .matches(isDisplayed())
        
        onView(withId("transfer_confirm_to_value"))
            .matches(isDisplayed())
        
        onView(withId("transfer_confirm_from_value"))
            .matches(isDisplayed())
        
        onView(withId("transfer_confirm_memo_value"))
            .matches(isDisplayed())
        
        onView(withId("transfer_confirm_cta_button"))
            .matches(isDisplayed())
    }
    
    func pressConfirmTransferCta() {
        onView(withId("transfer_confirm_cta_button"))
            .matchesNext(isDisplayed())
            .perform(click())
    }
}
