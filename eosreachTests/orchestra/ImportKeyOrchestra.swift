import Foundation

class ImportKeyOrchestra: Orchestra {
    
    func go(privateKey: String) {
        
        splashRobot.begin { it in
            it.selectImportKey()
        }
        
        importKeyRobot.begin { it in
            it.verifyImportKeyScreen()
            it.typePrivateKey(privateKey: privateKey)
        }
    }
}
