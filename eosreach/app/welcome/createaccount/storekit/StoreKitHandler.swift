import Foundation
import StoreKit

protocol Billing {
    func startConnection()
    func endConnection()
    func pay(product: SKProduct)
}

class BillingImpl : Billing {
    
    let storeKitRequest: StoreKitRequest
    
    let billingFlowDelegate: BillingFlowDelegate
    
    init(storeKitHandler: StoreKitHandler, billingFlowDelegate: BillingFlowDelegate) {
        self.storeKitRequest = StoreKitRequestFactory.create(storeKitHandler: storeKitHandler)
        self.billingFlowDelegate = billingFlowDelegate
    }
    
    func startConnection() {
        storeKitRequest.start()
    }
    
    func endConnection() {
        storeKitRequest.cancel()
    }
    
    func pay(product: SKProduct)  {
        if (SKPaymentQueue.canMakePayments()) {
            SKPaymentQueue.default().add(storeKitRequest.getStoreKitHandler())
            SKPaymentQueue.default().add(SKPayment(product: product))
        } else {
            self.billingFlowDelegate.cannotMakePayment()
        }
    }
}

class StoreKitHandler : NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    let billingConnectionDelegate: BillingConnectionDelegate
    let billingFlowDelegate: BillingFlowDelegate
    
    init (
        billingConnectionDelegate: BillingConnectionDelegate,
        billingFlowDelegate: BillingFlowDelegate
    ) {
        self.billingConnectionDelegate = billingConnectionDelegate
        self.billingFlowDelegate = billingFlowDelegate
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if (response.products.count > 0) {
            DispatchQueue.main.async {
                self.billingConnectionDelegate.success(skProduct: response.products[0])
            }
        } else {
            DispatchQueue.main.async {
                self.billingConnectionDelegate.skuNotFound()
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                self.billingFlowDelegate.purchasing()
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                self.billingFlowDelegate.success(transactionIdentifier: transaction.transactionIdentifier!)
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                self.billingFlowDelegate.failed()
            case .restored:
                break
            case .deferred:
                break // TODO: hmm?
            }
        }
    }
}

protocol BillingConnectionDelegate {
    func success(skProduct: SKProduct)
    func skuNotFound()
    func skuBillingUnavailable()
    func skuRequestFailed()
    func billingSetupFailed()
}

protocol BillingFlowDelegate {
    func cannotMakePayment()
    func purchasing()
    func success(transactionIdentifier: String)
    func failed()
    func deferred()
}
