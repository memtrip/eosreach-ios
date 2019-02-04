import Foundation
import EarlGrey

func onView(_ matcher: GREYMatcher) -> GREYInteraction {
    return EarlGrey.selectElement(with: matcher)
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

func withId(_ id: String) -> GREYMatcher {
    return grey_accessibilityID(id)
}

func withText(_ text: String) -> GREYMatcher {
    return grey_text(text)
}

func allOf(_ matchers: GREYMatcher...) -> GREYMatcher {
    return grey_allOf(matchers)
}

func descendantOf(_ matcher: GREYMatcher) -> GREYMatcher {
    return grey_descendant(matcher)
}

func ancestorOf(_ matcher: GREYMatcher) -> GREYMatcher {
    return grey_ancestor(matcher)
}

func withIdInParent(_ parentId: String, id: String) -> GREYMatcher {
    return ancestorOf(
        allOf(
            withId(id),
            ancestorOf(withId(parentId))
        )
    )
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

func scrollToBottomn() -> GREYAction {
    return grey_scrollToContentEdge(GREYContentEdge.bottom)
}
