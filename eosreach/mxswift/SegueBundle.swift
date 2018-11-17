import Foundation

struct SegueBundle {
    let identifier: String
    let model: BundleModel
}

protocol BundleSender {
    func setDestinationBundle(bundle: SegueBundle)
    func getDestinationBundle() -> SegueBundle?
}

protocol BundleModel {
}
