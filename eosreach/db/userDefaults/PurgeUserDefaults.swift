import Foundation

class PurgeUserDefaults {

    private let defaults = UserDefaults.standard

    func purgeAll() {
        defaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        defaults.synchronize()
    }
}
