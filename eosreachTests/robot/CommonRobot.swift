import Foundation
import EarlGrey

class CommonRobot : Robot {
    
    func verifyErrorView(
        parentId: String,
        titleText: String,
        bodyText: String
    ) {
        onView(allOf(
            withId("error_view_title"),
            withIdInParent(parentId, id: "error_view")
        ))
            .matchesNext(isDisplayed())
            .matches(withText(titleText))
        
        onView(allOf(
            withId("error_view_body"),
            withIdInParent(parentId, id: "error_view")
        ))
            .matchesNext(isDisplayed())
            .matches(withText(bodyText))
    }
    
    func selectRetryButton(parentId: String) {
        
        onView(allOf(
            withId("error_view_retry"),
            withIdInParent(parentId, id: "error_view")
        ))
            .matchesNext(isDisplayed())
            .perform(click())
    }
    
    func selectToolbarBackButton() {
        
        onView(withId("app_toolbar_back"))
            .matchesNext(isDisplayed())
            .perform(click())
    }
    
    func selectDialogOKButton() {
        onView(withText("OK"))
            .matchesNext(isDisplayed())
            .perform(click())
    }
}
