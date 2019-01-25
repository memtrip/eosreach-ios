import Foundation

class ImportKeyRobot : Robot {
    
    func verifyImportKeyScreen() {
        onView(withId("import_key_toolbar"))
            .matches(isDisplayed())
    }
    
    func typePrivateKey(privateKey: String) {
        onView(withId("import_key_private_key_value_input"))
            .matches(isDisplayed())
            .perform(replaceText(privateKey))
    }
}
