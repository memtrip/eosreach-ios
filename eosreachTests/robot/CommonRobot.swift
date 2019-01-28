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
            self.matchInParent(parentId)
        ))
            .matchesNext(isDisplayed())
            .matches(withText(titleText))
        
        onView(allOf(
            withId("error_view_body"),
            self.matchInParent(parentId)
        ))
            .matchesNext(isDisplayed())
            .matches(withText(bodyText))
    }
    
    // account_error_container
    func selectRetryButton(parentId: String) {
        
        onView(allOf(
            withId("error_view_retry"),
            self.matchInParent(parentId)
        ))
            .matchesNext(isDisplayed())
            .perform(click())
    }
    
    private func matchInParent(_ parentId: String) -> GREYMatcher {
        return ancestorOf(
            allOf(
                withId("error_view"),
                ancestorOf(withId(parentId))
            )
        )
    }
}
