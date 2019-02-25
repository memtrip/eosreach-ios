import Foundation

class BandwidthRobot : Robot {

    func verifyManageBandwidthScreen() {
        onView(withId("delegate_bandwidth_net_amount"))
            .matches(isDisplayed())
        
        onView(withId("delegate_bandwidth_cpu_amount"))
            .matches(isDisplayed())
    
        onView(withId("delegate_bandwidth_target_account"))
            .matches(isDisplayed())
        
        onView(withId("delegate_bandwidth_transfer_perm"))
            .matches(isDisplayed())
        
        onView(withId("delegate_bandwidth_delegate_button"))
            .matches(isDisplayed())
    }
    
    func selectUndelegateTab() {
        onView(withText("Undelegate"))
            .matchesNext(isDisplayed())
            .perform(click())
    }
    func enterNetBalance(value: String, prefix: String) {
        onView(withId("\(prefix)net_amount"))
            .matchesNext(isDisplayed())
            .perform(replaceText(value))
    }
    
    func enterCpuBalance(value: String, prefix: String) {
        onView(withId("\(prefix)cpu_amount"))
            .matchesNext(isDisplayed())
            .perform(replaceText(value))
    }
    
    func enterTargetAccount(value: String, prefix: String) {
        onView(withId("\(prefix)target_account"))
            .matchesNext(isDisplayed())
            .perform(replaceText(value))
    }
    
    func verifyBandwidthConfirmScreen() {
        onView(withId("confirm_bandwidth_toolbar"))
            .matches(isDisplayed())
        
        onView(withId("confirm_bandwidth_account_name_label"))
            .matches(isDisplayed())
        
        onView(withId("confirm_bandwidth_cpu_value_label"))
            .matches(isDisplayed())
        
        onView(withId("confirm_bandwidth_net_value_label"))
            .matches(isDisplayed())
        
        onView(withId("confirm_bandwidth_cta_button"))
            .matches(isDisplayed())
    }
    
    func verifyBandwidthConfirmCpuBalance(balance: String) {
        onView(withId("confirm_bandwidth_cpu_value_label"))
            .matchesNext(isDisplayed())
            .matches(withText(balance))
    }
    
    func verifyBandwidthConfirmNetBalance(balance: String) {
        onView(withId("confirm_bandwidth_net_value_label"))
            .matchesNext(isDisplayed())
            .matches(withText(balance))
    }
    
    func verifyDelegateFundsPerm() {
        onView(withId("confirm_bandwidth_delegate_funds_perm_label"))
            .matches(isDisplayed())
    }
    
    func selectBandwidthConfirmButton() {
        onView(withId("confirm_bandwidth_cta_button"))
            .matchesNext(isDisplayed())
            .perform(click())
    }
}
