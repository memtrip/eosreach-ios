import Foundation

class ImportKeyOrchestra: Orchestra {
    
    func go(privateKey: String) {
        splashRobot.selectImportKey()
        importKeyRobot.verifyImportKeyScreen()
        importKeyRobot.typePrivateKey(privateKey: privateKey)
    }
}
