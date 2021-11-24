//
//  ApphudHelper.swift
//  italianLanguage
//
//  Created by Александр Шендрик on 30.08.2021.
//

import Foundation
import ApphudSDK
import FirebaseCrashlytics

class ApphudHelper: ObservableObject {
    @Published var isPremium : Bool
    var payWallsText : [PayWallText]
    var payWallsText2 : [PayWallText2]
    @Published var curPayWallText : PayWallText
    @Published var curPayWallText2 : PayWallText2
    
    @Published var pwTitleText : String = ""
    
    var paywalls : [ApphudPaywall]?
    
    var allProducts : [ApphudProduct] = [ApphudProduct]()
    var product : ApphudProduct?
    var timer : Timer?
    var skProdInfo : [SKProdInfo] = [SKProdInfo]()
    //
    let userdefault = UserDefaults.standard
    
    //Сохраяем цены
    @Published var SKtrial_time1 : String = ""
    @Published var SKprice1 : String = ""
    @Published var SKtime1 : String = ""
    @Published var purchaseId1 : String?
    
    
    @Published var Text1 : String = " "
    @Published var Tittle1 : String = " "
    @Published var ButtonText : String = " "
    @Published var Price1 : String = " "
    
    var purchaseId21 : String = ""
    var purchaseId22 : String = ""
    var purchaseId23 : String = ""
    
    @Published var skProdInfo21 : SKProdInfo = SKProdInfo(purchaseId: "", price: "", time: "", trial_time: "", week_price: "")
    @Published var skProdInfo22 : SKProdInfo = SKProdInfo(purchaseId: "", price: "", time: "", trial_time: "", week_price: "")
    @Published var skProdInfo23 : SKProdInfo = SKProdInfo(purchaseId: "", price: "", time: "", trial_time: "", week_price: "")
    
    init() {
        Apphud.start(apiKey: "app_XwfmyJsn9EGGYmLQ6ETUrXn8FVjLLv")
        self.paywalls = Apphud.paywalls
        
        self.payWallsText = Bundle.main.decodePayWallsText("PayWallText.json")
        self.payWallsText2 = Bundle.main.decodePayWallsText2("PayWallText2.json")
        self.curPayWallText = self.payWallsText[0]
        self.curPayWallText2 = self.payWallsText2[0]
        
        let langStr = Locale.current.languageCode
        for text in payWallsText {
            if text.lang == langStr {
                curPayWallText = text
            }
        }
        
        for text in payWallsText2 {
            if text.lang == langStr {
                curPayWallText2 = text
            }
        }

        if paywalls != nil {
            self.product = paywalls![0].products[0]
        }
        
        self.isPremium = Apphud.hasActiveSubscription()
//        self.isPremium = true
        
        getPayWalls()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.upadtePayWall()
            self.isPremium = Apphud.hasActiveSubscription()
        }
        
        let userdefault = UserDefaults.standard
        if userdefault.bool(forKey: "SKwasSaved") {
            self.SKtrial_time1 = userdefault.string(forKey: "SKtrial_time") ?? ""
            self.SKprice1 = userdefault.string(forKey: "SKprice")  ?? ""
            self.SKtime1 = userdefault.string(forKey: "SKtime") ?? ""
            self.purchaseId1 = userdefault.string(forKey: "SKprodID") ?? nil
            
            //
            self.Text1 = userdefault.string(forKey: "Tittle1") ?? ""
            self.Tittle1 = userdefault.string(forKey: "Tittle1") ?? ""
            self.Price1 = userdefault.string(forKey: "Price1") ?? ""
            self.ButtonText = userdefault.string(forKey: "ButtonText") ?? ""

        }
        upadtePayWall()
    }
    
    func choosePWText() {
        let langStr = Locale.current.languageCode
        for text in payWallsText {
            if text.lang == langStr {
                curPayWallText = text
                userdefault.set(purchaseId1, forKey: "SKprodID")
                
                self.Text1 = curPayWallText.text
                self.Tittle1 = curPayWallText.title
                self.Price1 = curPayWallText.price
                self.ButtonText = curPayWallText.ButtonText
                self.purchaseId1 = curPayWallText.purchaseId
                
                userdefault.set(self.Text1, forKey: "Text1")
                userdefault.set(self.Tittle1, forKey: "Tittle1")
                userdefault.set(self.Price1, forKey: "Price1")
                userdefault.set(self.ButtonText, forKey: "ButtonText")
                userdefault.set(self.purchaseId1, forKey: "purchaseId1")
            }
        }
    }
    
    func choosePWText2() {
        let langStr = Locale.current.languageCode
        for text in payWallsText2 {
            if text.lang == langStr {
                curPayWallText2 = text
                purchaseId21 = text.purchaseId1
                purchaseId22 = text.purchaseId2
                purchaseId23 = text.purchaseId3
            }
        }
        
    }
    
    private func getPayWalls() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] timer in
            if let self = self{
                if self.paywalls == nil && self.purchaseId1 != nil {
                    self.upadtePayWall()
                }
            }
        }
    }
    
    func quickPurchase() {
        self.product = self.allProducts.first(where: {$0.productId == purchaseId1})
        if self.product != nil {
            self.purchase(product: self.product!)
        }
    }
    
    func quickPurchase(selectedProd: Int) {
        var prodId = ""
        switch selectedProd{
        case 0:
            prodId = self.purchaseId21
        case 1:
            prodId = self.purchaseId22
        case 2:
            prodId = self.purchaseId23
        default:
            prodId = self.purchaseId21
        }
        
        self.product = self.allProducts.first(where: {$0.productId == prodId})
        if self.product != nil {
            self.purchase(product: self.product!)
        }
    }
    
    func purchase(product : ApphudProduct) {
        Apphud.purchase(product) { result in
           if let subscription = result.subscription, subscription.isActive(){
                self.isPremium = true
           } else if let purchase = result.nonRenewingPurchase, purchase.isActive(){
              // has active non-renewing purchase
           } else {
              // handle error or check transaction status.
           }
        }
    }
    
    func upadtePayWall() {
        self.paywalls = Apphud.paywalls
        print("upadtePayWall Start")
        if paywalls != nil {
            print("upadtePayWall get paywalls")
            for wall in paywalls! {
                print("upadtePayWall wall")
                for prod in wall.products {
                    print(prod.productId)
                    if prod.skProduct != nil {
                        self.allProducts.append(prod)
                        print("skProduct OK")
                    }
                }
            }
            self.saveSKProduct()
        }
    }
    
    
    
    /// Восстановть покупки
    func restore(){
        Apphud.restorePurchases{ subscriptions, purchases, error in
           if Apphud.hasActiveSubscription(){
                self.isPremium = true
           } else {
            self.isPremium = false
             // no active subscription found, check non-renewing purchases or error
           }
        }
    }
    
    func hasActiveSubscription () -> Bool {
        return Apphud.hasActiveSubscription()
    }
    
    func getPayWallText() -> PayWallText {
        let langStr = Locale.current.languageCode
        
        for text in payWallsText {
            if text.lang == langStr {
                return text
            }
        }
        return payWallsText[0]
    }

    
    
    func saveSKProduct() {
        skProdInfo = [SKProdInfo]()
        for prod in self.allProducts {
            var trial_time = ""
            var time = ""
            var weeks = 1
            var week_price = ""
            
            let price = "\(prod.skProduct!.price.stringValue) \(prod.skProduct!.priceLocale.currencySymbol ?? "")"
            
            if prod.skProduct!.introductoryPrice != nil{
                trial_time = "\(prod.skProduct!.introductoryPrice!.subscriptionPeriod.numberOfUnits)"
            }
            
            if prod.skProduct!.subscriptionPeriod != nil {
                weeks = prod.skProduct!.subscriptionPeriod!.numberOfUnits / 7
                weeks = weeks != 0 ? weeks : 1
                week_price = "\(prod.skProduct!.price.intValue / weeks)\(prod.skProduct!.priceLocale.currencySymbol ?? "")"
            }
                
            time = "\(prod.skProduct!.subscriptionPeriod!.numberOfUnits)"
            if prod.productId == purchaseId1 {
                self.SKprice1 = price
                self.SKtime1 = time
                self.SKtrial_time1 = trial_time
                
                userdefault.set(true, forKey: "SKwasSaved")
                userdefault.set(SKprice1, forKey: "SKprice")
                userdefault.set(SKtrial_time1, forKey: "SKtrial_time")
                userdefault.set(SKtime1, forKey: "SKtime")
            }
            
            skProdInfo.append(SKProdInfo(purchaseId: prod.productId, price: price, time: time, trial_time: trial_time, week_price: week_price))
        }
        
        self.skProdInfo21 = self.getSKProdInfo(productId: purchaseId21)
        self.skProdInfo22 = self.getSKProdInfo(productId: purchaseId22)
        self.skProdInfo23 = self.getSKProdInfo(productId: purchaseId23)
        
        print("self.skProdInfo21 \(self.skProdInfo21.purchaseId) \(self.skProdInfo21.price)")
        print("self.skProdInfo22 \(self.skProdInfo22.purchaseId) \(self.skProdInfo22.price)")
        print("self.skProdInfo23 \(self.skProdInfo23.purchaseId) \(self.skProdInfo23.price)")
        
    }
    
    func getSKProdInfo(productId : String) -> SKProdInfo {
        for info in self.skProdInfo {
            if info.purchaseId == productId {
                print("info \(info.purchaseId) OK get")
                return info
            }
        }
        return SKProdInfo(purchaseId: productId, price: "", time: "", trial_time: "", week_price: "")
    }
}

struct SKProdInfo {
    var purchaseId : String
    var price : String
    var time : String
    var trial_time : String
    var week_price : String
}
