
import Foundation
import StoreKit
import Pushwoosh
import Adjust

protocol IAPManagerProtocol_MTW: AnyObject {
    func infoAlert_MTW(title: String, message: String)
    func goToTheApp_MTW()
    func failed_MTW()
}

class IAPManager_MTW: NSObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    static let shared = IAPManager_MTW()
    
    weak var  transactionsDelegate_MTW: IAPManagerProtocol_MTW?
    
    private(set) var isSubscribed = false
    private(set) var isFirstFuncEnabled = false
    private(set) var isSecondFuncEnabled = false
    
    public var  localizablePrice = "$4.99"
    private var  inMain: SKProduct?
    private var  inUnlockContent: SKProduct?
    private var  inUnlockFunc: SKProduct?
    private var  inUnlockOther: SKProduct?
    
    
    private var mainProduct = Configurations_MTW.mainSubscriptionID
    private var unlockContentProduct = Configurations_MTW.unlockContentSubscriptionID
    private var unlockFuncProduct = Configurations_MTW.unlockFuncSubscriptionID
    private var unlockOther = Configurations_MTW.unlockerThreeSubscriptionID
    
    private var secretKey = Configurations_MTW.subscriptionSharedSecret
    
    private var isRestoreTransaction = true
    
    private let iapError      = NSLocalizedString("error_iap", comment: "")
    private let prodIDError   = NSLocalizedString("inval_prod_id", comment: "")
    private let restoreError  = NSLocalizedString("faledRestore", comment: "")
    private let purchaseError = NSLocalizedString("notPurchases", comment: "")
    
    public var productBuy : PremiumMainControllerStyle_MTW = .mainProduct
    
    public func loadProductsFunc_MTW() {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        SKPaymentQueue.default().add(self)
        let request = SKProductsRequest(productIdentifiers:[mainProduct,unlockContentProduct,unlockFuncProduct,unlockOther])
        request.delegate = self
        request.start()
    }
         
    
    public func doPurchase_MTW() {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        switch productBuy {
          case .mainProduct:
            if let inMain {
                processPurchase_MTW(for: inMain, with: Configurations_MTW.mainSubscriptionID)
            }
            else {
                transactionsDelegate_MTW?.infoAlert_MTW(title: "Error", message: "Product is empty!")
            }
          case .unlockContentProduct:
            if let inUnlockContent {
                processPurchase_MTW(for: inUnlockContent, with: Configurations_MTW.unlockContentSubscriptionID)
            }
            else {
                transactionsDelegate_MTW?.infoAlert_MTW(title: "Error", message: "Product is empty!")
            }
          case .unlockFuncProduct:
            if let inUnlockFunc {
                processPurchase_MTW(for: inUnlockFunc, with: Configurations_MTW.unlockFuncSubscriptionID)
            }
            else {
                transactionsDelegate_MTW?.infoAlert_MTW(title: "Error", message: "Product is empty!")
            }
        case .unlockOther:
            if let inUnlockOther {
                processPurchase_MTW(for: inUnlockOther, with: Configurations_MTW.unlockerThreeSubscriptionID)
            }
            else {
                transactionsDelegate_MTW?.infoAlert_MTW(title: "Error", message: "Product is empty!")
            }
        }
    }
    
    public func localizedPrice_MTW() -> String {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        guard NetworkStatusMonitor_MTW.shared.isNetworkAvailable else { return localizablePrice }
        switch productBuy {
          case .mainProduct:
            processProductPrice_MTW(for: inMain)
          case .unlockContentProduct:
            processProductPrice_MTW(for: inUnlockContent)
          case .unlockFuncProduct:
            processProductPrice_MTW(for: inUnlockFunc)
        case .unlockOther:
            processProductPrice_MTW(for: inUnlockOther)
        }
        return localizablePrice
    }
    
    private func getCurrentProduct_MTW() -> SKProduct? {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        switch productBuy {
        case .mainProduct:
            return self.inMain
        case .unlockContentProduct:
            return self.inUnlockContent
        case .unlockFuncProduct:
            return self.inUnlockFunc
        case .unlockOther:
            return self.inUnlockOther
        }
    }
    private func processPurchase_MTW(for product: SKProduct, with configurationId: String) {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        if product.productIdentifier.isEmpty {
        
            self.transactionsDelegate_MTW?.infoAlert_MTW(title: iapError, message: prodIDError)
        } else if product.productIdentifier == configurationId {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
    }
    
    
    public func doRestore_MTW() {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    private func completeRestoredStatusFunc_MTW(restoreProductID : String) {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        guard isRestoreTransaction else {
            return
        }
        
        isRestoreTransaction = false
        
        validateSubscriptionWithCompletionHandler_MTW(productIdentifier: restoreProductID) { [weak self] result in
            guard let self = self else {
                return
            }
            
            if result {
                self.transactionsDelegate_MTW?.goToTheApp_MTW()
            } else {
                self.transactionsDelegate_MTW?.infoAlert_MTW(title: self.restoreError, message: self.purchaseError)
            }
        }
    }
    
    
    public func completeAllTransactionsFunc_MTW() {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        let transactions = SKPaymentQueue.default().transactions
        for transaction in transactions {
            let transactionState = transaction.transactionState
            if transactionState == .purchased || transactionState == .restored {
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
    
    // Ваша собственная функция для проверки подписки.
    public func validateSubscriptionWithCompletionHandler_MTW(productIdentifier: String,_ resultExamination: @escaping (Bool) -> Void) {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        SKReceiptRefreshRequest().start()

        guard let receiptUrl = Bundle.main.appStoreReceiptURL,
              let receiptData = try? Data(contentsOf: receiptUrl) else {
            pushwooshSetSubTag_MTW(value: false)
            resultExamination(false)
            return
        }
        
        let receiptDataString = receiptData.base64EncodedString(options: [])
        
        let jsonRequestBody: [String: Any] = [
            "receipt-data": receiptDataString,
            "password": self.secretKey,
            "exclude-old-transactions": true
        ]
        
        let requestData: Data
        do {
            requestData = try JSONSerialization.data(withJSONObject: jsonRequestBody)
        } catch {
            print("Failed to serialize JSON: \(error)")
            pushwooshSetSubTag_MTW(value: false)
            resultExamination(false)
            return
        }
        #warning("replace to release")
//#if DEBUG
        let url = URL(string: "https://sandbox.itunes.apple.com/verifyReceipt")!
//#else
//        let url = URL(string: "https://buy.itunes.apple.com/verifyReceipt")!
//#endif
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = requestData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Failed to validate receipt: \(error) IAPManager_MTW")
                self.pushwooshSetSubTag_MTW(value: false)
                resultExamination(false)
                return
            }
            
            guard let data = data else {
                print("No data received from receipt validation IAPManager_MTW")
                self.pushwooshSetSubTag_MTW(value: false)
                resultExamination(false)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let latestReceiptInfo = json["latest_receipt_info"] as? [[String: Any]] {
                    for receipt in latestReceiptInfo {
                           if let receiptProductIdentifier = receipt["product_id"] as? String,
                              receiptProductIdentifier == productIdentifier,
                              let expiresDateMsString = receipt["expires_date_ms"] as? String,
                              let expiresDateMs = Double(expiresDateMsString) {
                               let expiresDate = Date(timeIntervalSince1970: expiresDateMs / 1000)
                               if expiresDate > Date() {
                                   DispatchQueue.main.async {
                                       self.pushwooshSetSubTag_MTW(value: true)
                                       resultExamination(true)
                                   }
                                   return
                               }
                           }
                       }
                }
            } catch {
                print("Failed to parse receipt data 🔴: \(error) IAPManager_MTW")
            }
            
            DispatchQueue.main.async {
                self.pushwooshSetSubTag_MTW(value: false)
                resultExamination(false)
            }
        }
        task.resume()
    }
    
    
    func validateSubscriptions_MTW(productIdentifiers: [String], completion: @escaping ([String: Bool]) -> Void) {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        var results = [String: Bool]()
        let dispatchGroup = DispatchGroup()
        
        for productIdentifier in productIdentifiers {
            dispatchGroup.enter()
            validateSubscriptionWithCompletionHandler_MTW(productIdentifier: productIdentifier) { isValid in
                results[productIdentifier] = isValid
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.updateSubscriptions(results)
            
            completion(results)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        Pushwoosh.sharedInstance().sendSKPaymentTransactions(transactions)
        for transaction in transactions {
            if let error = transaction.error as? NSError,
               error.domain == SKErrorDomain {
                switch error.code {
                case SKError.paymentCancelled.rawValue:
                    print("User cancelled the request IAPManager")
                case SKError.paymentNotAllowed.rawValue, SKError.paymentInvalid.rawValue, SKError.clientInvalid.rawValue, SKError.unknown.rawValue:
                    print("This device is not allowed to make the payment IAPManager")
                default:
                    break
                }
            }
            
            switch transaction.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                if let product = getCurrentProduct_MTW() {
                    if transaction.payment.productIdentifier == product.productIdentifier {
                        trackSubscription_MTW(transaction: transaction, product:  product)
                        transactionsDelegate_MTW?.goToTheApp_MTW()
                    }
                    
                }
                
                if transaction.payment.productIdentifier == self.inMain?.productIdentifier {
                    isSubscribed = true
                }
                else if transaction.payment.productIdentifier == self.inUnlockFunc?.productIdentifier {
                    isFirstFuncEnabled = true
                }
                else if transaction.payment.productIdentifier == self.inUnlockContent?.productIdentifier {
                    isSecondFuncEnabled = true
                }
                //  print("Purchased IAPManager")
                
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionsDelegate_MTW?.failed_MTW()
                print("Failed IAPManager")
                
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                if let product = getCurrentProduct_MTW() {
                    trackSubscription_MTW(transaction: transaction, product:  product)
                    completeRestoredStatusFunc_MTW(restoreProductID: product.productIdentifier)
                }
                print("Restored IAPManager")
                if transaction.payment.productIdentifier == self.inMain?.productIdentifier {
                    isSubscribed = true
                }
                else if transaction.payment.productIdentifier == self.inUnlockFunc?.productIdentifier {
                    isFirstFuncEnabled = true
                }
                else if transaction.payment.productIdentifier == self.inUnlockContent?.productIdentifier {
                    isSecondFuncEnabled = true
                }
            case .purchasing, .deferred:
                print("Purchasing IAPManager")
                
            default:
                print("Default IAPManager")
            }
        }
        
        completeAllTransactionsFunc_MTW()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        print("requesting to product IAPManager_MTW")
        
        if let invalidIdentifier = response.invalidProductIdentifiers.first {
            print("Invalid product identifier:", invalidIdentifier , "IAPManager_MTW")
        }
        
        guard !response.products.isEmpty else {
            print("No products available IAPManager_MTW")
            return
        }
        
        response.products.forEach({ productFromRequest in
            switch productFromRequest.productIdentifier {
            case Configurations_MTW.mainSubscriptionID:
                inMain = productFromRequest
            case Configurations_MTW.unlockContentSubscriptionID:
                inUnlockContent = productFromRequest
            case Configurations_MTW.unlockFuncSubscriptionID:
                inUnlockFunc = productFromRequest
            case Configurations_MTW.unlockerThreeSubscriptionID:
                inUnlockOther = productFromRequest
            default:
                print("error IAPManager_MTW")
                return
            }
            print("Found product: \(productFromRequest.productIdentifier) IAPManager_MTW")
        })
    }
    
    private func processProductPrice_MTW(for product: SKProduct?) {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = product?.priceLocale ?? Locale(identifier: "en-US")
        
        if let product,
           let formattedPrice = numberFormatter.string(from: product.price) {
            self.localizablePrice = formattedPrice
        } else {
            self.localizablePrice = "4.99 $"
        }
    }
    
    private func pushwooshSetSubTag_MTW(value : Bool) {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        
        var tag = Configurations_MTW.mainSubscriptionPushTag
        
        switch productBuy {
        case .mainProduct:
             print("continue IAPManager_MTW")
        case .unlockContentProduct:
            tag = Configurations_MTW.unlockContentSubscriptionPushTag
        case .unlockFuncProduct:
            tag = Configurations_MTW.unlockFuncSubscriptionPushTag
        case .unlockOther:
            tag = Configurations_MTW.unlockerThreeSubscriptionPushTag
        }
        
        Pushwoosh.sharedInstance().setTags([tag: value]) { error in
            if let err = error {
                print(err.localizedDescription)
                print("send tag error IAPManager_MTW")
            }
        }
    }

    private func trackSubscription_MTW(transaction: SKPaymentTransaction, product: SKProduct) {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        if let receiptURL = Bundle.main.appStoreReceiptURL,
           let receiptData = try? Data(contentsOf: receiptURL) {
            
            let price = NSDecimalNumber(decimal: product.price.decimalValue)
            let currency = product.priceLocale.currencyCode ?? "USD"
            let transactionId = transaction.transactionIdentifier ?? ""
            let transactionDate = transaction.transactionDate ?? Date()
            let salesRegion = product.priceLocale.regionCode ?? "US"
            
            if let subscription = ADJSubscription(price: price, currency: currency, transactionId: transactionId, andReceipt: receiptData) {
                subscription.setTransactionDate(transactionDate)
                subscription.setSalesRegion(salesRegion)
                Adjust.trackSubscription(subscription)
            }
        }
    }
    
    private func updateSubscriptions(_ result: [String: Bool]) {
        isSubscribed = result[Configurations_MTW.mainSubscriptionID] ?? false
        isFirstFuncEnabled = result[Configurations_MTW.unlockFuncSubscriptionID] ?? false
        isSecondFuncEnabled = result[Configurations_MTW.unlockContentSubscriptionID] ?? false
    }
    
}
