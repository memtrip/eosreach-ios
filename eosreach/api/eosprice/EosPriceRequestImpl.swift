import Foundation
import RxSwift
import eosswift

class EosPriceRequestImpl : EosPriceRequest {
    
    private let eosPriceApi = ReachApiModule.eosPriceApi()
    
    func getPrice(currencyCode: String) -> Single<Result<EosPrice, EosPriceError>> {
        return eosPriceApi.getPrice(currency: currencyCode.uppercased()).map { response in
            if (response.success) {
                return Result(data: EosPrice(
                    value: response.body!.value,
                    currency: response.body!.currency))
            } else {
                if (response.statusCode == 406) {
                    return Result(error: EosPriceError.unsupportedCurrency)
                } else {
                    return Result(error: EosPriceError.generic)
                }
            }
        }
    }
}
