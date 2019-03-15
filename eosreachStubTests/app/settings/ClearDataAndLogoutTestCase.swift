import Foundation
@testable import stub

class ClearDataAndLogoutTestCase : TestCase {
    
    func testClearDataAndLogout() {
        
        importKeyOrchestra
            .go(privateKey: "5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3")
        
        accountRobot.begin { it in
            it.selectMenu()
            it.selectMenuSettings()
        }
        
        settingsRobot.begin { it in
            it.verifySettingsScreen()
            it.selectClearDataAndLogout()
        }
        
        commonRobot.selectDialogOKButton()
        
        importKeyOrchestra
            .go(privateKey: "5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3")
        
        // confirm that the side navigation functions correctly, issues
        // with the backstack can break this functionality!
        accountRobot.begin { it in
            it.verifyAccountScreen()
            it.selectMenu()
            it.selectMenuImportKey()
        }
        
        importKeyRobot.verifyImportKeyScreen()
        
        commonRobot.selectToolbarBackButton()
    }
}
