import Foundation

enum ConfirmBandwidthIntent: MxIntent {
    case idle
    case start(bandwidthFormBundle: BandwidthFormBundle)
    case commit(bandwidthBundle: BandwidthFormBundle)
}
