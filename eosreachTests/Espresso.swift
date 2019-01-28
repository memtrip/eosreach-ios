import Foundation
import EarlGrey

func onView(_ matcher: GREYMatcher) -> GREYInteraction {
    return EarlGrey.selectElement(with: matcher)
}

func withId(_ id: String) -> GREYMatcher {
    return grey_accessibilityID(id)
}

extension GREYInteraction {
    
    func matches(_ matcher: GREYMatcher) {
        self.assert(matcher)
    }
    
    func matchesNext(_ matcher: GREYMatcher) -> GREYInteraction {
        self.assert(matcher)
        return self
    }
}

//
// MARK :- matchers
//
func isDisplayed() -> GREYMatcher {
    return grey_sufficientlyVisible()
}

func withText(_ text: String) -> GREYMatcher {
    return grey_text(text)
}

//
// MARK :- actions
//
func click() -> GREYAction {
    return grey_tap()
}

func typeText(_ text: String) -> GREYAction {
    return grey_typeText(text)
}

func replaceText(_ text: String) -> GREYAction {
    return grey_replaceText(text)
}
