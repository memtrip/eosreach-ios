import Foundation
import RxSwift
import eosswift

class RamPriceRequestImpl : RamPriceRequest {

    private let getRamPrice = GetRamPrice(chainApi: ChainApiModule.create())

    func getRamPrice(symbol: String) -> Single<Result<Balance, RamPriceError>> {
        return getRamPrice.getPricePerKilobyte().map { price in
            return Result(data: Balance(amount: price.truncate(places: 8), symbol: symbol))
        }.catchErrorJustReturn(Result(error: RamPriceError.genericError))
    }
}
