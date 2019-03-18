import Foundation

class ActionsRobot : Robot {
    
    func selectTransferButton() {
        
        onView(withId("actions_transfer_button"))
            .matchesNext(isDisplayed())
            .perform(click())
    }
}
