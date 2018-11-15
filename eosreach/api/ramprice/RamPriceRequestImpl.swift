import Foundation
import RxSwift
import eosswift

class RamPriceRequestImpl : RamPriceRequest {

    private let getRamPrice = GetRamPrice(chainApi: ChainApiModule.create())

    func getRamPrice(symbol: String) -> Single<Result<Balance, RamPriceError>> {
        return getRamPrice.getPricePerKilobyte().map { price in
            let formattedPrice = String(format: "%.8", price)
            return Result(data: BalanceFormatter.deserialize(balance: "\(formattedPrice) \(symbol)"))
        }.catchErrorJustReturn(Result(error: RamPriceError.genericError))
    }
}
