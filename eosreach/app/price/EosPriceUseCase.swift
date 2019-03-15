import Foundation
import RxSwift

class EosPriceUseCase {
    
    private let eosPriceValue = EosPriceValue()
    private let eosPriceCurrencyPair = EosPriceCurrencyPair()
    private let eosPriceLastUpdated = EosPriceLastUpdated()
    private let eosPriceRequest = EosPriceRequestImpl()
    
    private let TEN_MINUTES = 600.0
    
    func getPrice() -> Single<EosPrice> {
        if (!expired(lastUpdated: eosPriceLastUpdated.get())) {
            return Single.just(EosPrice(value: Double(eosPriceValue.get()), currency: eosPriceCurrencyPair.get()))
        } else {
            return eosPriceRequest.getPrice(currencyCode: eosPriceCurrencyPair.get()).map { response in
                if (response.success()) {
                    self.eosPriceLastUpdated.put(value: Date().timeIntervalSince1970)
                    self.eosPriceValue.put(value: Float(response.data!.value))
                    return EosPrice(value: Double(self.eosPriceValue.get()), currency: self.eosPriceCurrencyPair.get())
                } else {
                    return EosPrice.unavailable()
                }
            }
        }
    }
    
    func refreshPrice(currencyCode: String) -> Single<EosPrice> {
        return eosPriceRequest.getPrice(currencyCode: currencyCode).map { response in
            if (response.success()) {
                self.eosPriceLastUpdated.clear()
                self.eosPriceCurrencyPair.put(value: response.data!.currency)
                self.eosPriceValue.put(value: Float(response.data!.value))
                return response.data!
            } else {
                return EosPrice.unavailable()
            }
        }
    }
    
    private func expired(lastUpdated: Double) -> Bool {
        return lastUpdated == 0 || (Date().timeIntervalSince1970 - TEN_MINUTES) > lastUpdated
    }
}
