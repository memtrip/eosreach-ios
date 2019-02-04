import Foundation

class VoteRobot : Robot {
    
    func verifyNotVotedScreen() {
        
        onView(withId("vote_title_label"))
            .matches(isDisplayed())
        
        onView(withId("vote_no_vote_body_label"))
            .matches(isDisplayed())
        
        onView(withId("vote_no_vote_castvote_button"))
            .matches(isDisplayed())
    }
    
    func selectVoteForUs() {
        
        onView(withId("vote_no_vote_castvote_button"))
            .matchesNext(isDisplayed())
            .perform(click())
    }
}
