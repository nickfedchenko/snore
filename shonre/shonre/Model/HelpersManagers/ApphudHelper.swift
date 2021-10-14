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
    
    var allProducts : [ApphudProduct] = [ApphudProduct]()
    var product : ApphudProduct?
    var timer : Timer?
    
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
                    print(prod.skProduct)
                    if prod.skProduct != nil {
                        self.allProducts.append(prod)
                        print("upadtePayWall Secces")
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
        for prod in self.allProducts {
            var trial_time = ""
            var time = ""
            
            
            let price = "\(prod.skProduct!.price.stringValue) \(prod.skProduct!.priceLocale.currencySymbol ?? "")"
            
            if prod.skProduct!.introductoryPrice != nil{
                trial_time = "\(prod.skProduct!.introductoryPrice!.subscriptionPeriod.numberOfUnits)"
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
            
        }
    }
    
}
