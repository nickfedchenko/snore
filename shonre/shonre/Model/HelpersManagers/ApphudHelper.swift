//
//  ApphudHelper.swift
//  italianLanguage
//
//  Created by Александр Шендрик on 30.08.2021.
//

import Foundation
import ApphudSDK

class ApphudHelper: ObservableObject {
    @Published var isPremium : Bool
    var payWallsText : [PayWallText]
    @Published var curPayWallText : PayWallText
    
    @Published var pwTitleText : String = ""
    
    var paywalls : [ApphudPaywall]?
    
    var product : ApphudProduct?
    var timer : Timer?
    
    //
    @Published var purchaseId : String?
    
    //Сохраяем цены
    var SKtrial_time : String = ""
    var SKprice : String = ""
    var SKtime : String = ""
    
    init() {
        Apphud.start(apiKey: "app_XwfmyJsn9EGGYmLQ6ETUrXn8FVjLLv")
        self.paywalls = Apphud.paywalls
        
        self.payWallsText = Bundle.main.decodePayWallsText("PayWallText.json")
        self.curPayWallText = self.payWallsText[0]
        
        let langStr = Locale.current.languageCode
        for text in payWallsText {
            if text.lang == langStr {
                curPayWallText = text
            }
        }

        
        if paywalls != nil {
            self.product = paywalls![0].products[0]
        }
        
        self.isPremium = Apphud.hasActiveSubscription()
        
        
        getPayWalls()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.upadtePayWall()
            self.isPremium = Apphud.hasActiveSubscription()
        }
        
        let userdefault = UserDefaults.standard
        if userdefault.bool(forKey: "SKwasSaved") {
            self.SKtrial_time = userdefault.string(forKey: "SKtrial_time") ?? ""
            self.SKprice = userdefault.string(forKey: "SKprice")  ?? ""
            self.SKtime = userdefault.string(forKey: "SKtime") ?? ""
            self.purchaseId = userdefault.string(forKey: "SKprodID") ?? nil
        }
        
        self.pwTitleText = self.getPWTitle()
    }
    
    private func getPayWalls() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] timer in
            if let self = self{
                if self.paywalls == nil {
                    self.upadtePayWall()
                    let langStr = Locale.current.languageCode
                    for text in self.payWallsText {
                        if text.lang == langStr {
                            self.curPayWallText = text
                        }
                    }
                }
            }
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
        if paywalls != nil {
            if self.purchaseId == nil {
                print("upadtePayWall YESS")
                for wall in paywalls! {
                    for prod in wall.products {
                        print(prod.productId)
                        if prod.skProduct != nil {
                            print("upadtePayWall SKProd YESS")
                            self.product = prod
                            self.saveSKProduct(prod)
                            self.pwTitleText = self.getPWTitle()
                        }
                    }
                }
            } else {
                for wall in paywalls! {
                    for prod in wall.products {
                        if prod.skProduct != nil {
                            if prod.productId == self.purchaseId {
                                self.product = prod
                                self.saveSKProduct(prod)
                                self.pwTitleText = self.getPWTitle()
                                return
                            }
                        }
                    }
                }
            }
        }
    }
    
    func setpurchaseId() {
        self.purchaseId = payWallsText[0].purchaseId
        self.upadtePayWall()
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
    
    func getPWTitle() -> String {
        let tittle = self.getPayWallText().title
        
        var free_time = SKtrial_time
        var price = SKprice
        var time = SKtime
        
        if product != nil {
            free_time = "\(product!.skProduct!.introductoryPrice!.subscriptionPeriod.numberOfUnits)"
            price = "\(product!.skProduct!.price.stringValue) \(product!.skProduct!.priceLocale.currencySymbol ?? "")"
            time = "\(product!.skProduct!.subscriptionPeriod!.numberOfUnits)"
        }
        
        let newTettle = tittle.replacingOccurrences(of: "%free_time%", with: free_time).replacingOccurrences(of: "%price%", with: price).replacingOccurrences(of: "%time%", with: time)
        return newTettle
    }
    
    func saveSKProduct(_ prod: ApphudProduct) {
        let skProduct = prod.skProduct!
        self.SKprice = "\(skProduct.price.stringValue) \(skProduct.priceLocale.currencySymbol ?? "")"
        
        if skProduct.introductoryPrice != nil{
            self.SKtrial_time = "\(skProduct.introductoryPrice!.subscriptionPeriod.numberOfUnits)"
        }
        
        if skProduct.subscriptionPeriod != nil{
            self.SKtime = "\(skProduct.subscriptionPeriod!.numberOfUnits)"
        }
        
        if skProduct.productIdentifier != nil{
            self.purchaseId = "\(skProduct.productIdentifier)"
        }
        
        let userdefault = UserDefaults.standard
        userdefault.set(true, forKey: "SKwasSaved")
        userdefault.set(SKprice, forKey: "SKprice")
        userdefault.set(SKtrial_time, forKey: "SKtrial_time")
        userdefault.set(SKtime, forKey: "SKtime")
        userdefault.set(purchaseId, forKey: "SKprodID")
        print("prod saved")
    }
}
