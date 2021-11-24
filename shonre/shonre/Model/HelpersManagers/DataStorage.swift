//
//  DataStorage.swift
//  shonre
//
//  Created by Александр Шендрик on 01.10.2021.
//

import Foundation
import Combine
import Amplitude
import Firebase
import ApphudSDK

class DataStorage : ObservableObject {
    
    // Работа с данными
    @Published var soundAnalyzer : SoundAnalyzer
    @Published var soundStack : WhiteSoundStack
    @Published var PWnum : Int = 0
    // Отображение графики
    @Published var viewControll : ViewControll = ViewControll()
    
    // Работа с окружением
    var apphudHelper : ApphudHelper = ApphudHelper()
    var NCH : NotificationHelper
    
    // User Deafaults and Keys
    let userdefault = UserDefaults.standard
    let firstLoad = "firsLoad"
    
    // View Models
    var cancellables = Set<AnyCancellable>()
    
#if DEBUG
    var isTest : Bool = true
#else
    //MARK: - В релизе ВСЕГДА false
    var isTest : Bool = false
#endif
    
    init(notificationCenter : UNUserNotificationCenter) {
        FirebaseApp.configure()
        self.soundAnalyzer = SoundAnalyzer()
        self.soundStack = WhiteSoundStack()
        self.NCH = NotificationHelper(notificationCenter: notificationCenter)
        
        Amplitude.instance().trackingSessionEvents = true
        Amplitude.instance().initializeApiKey("05a7087670a743098b669571309fdae7")
        Amplitude.instance().logEvent("app_start")
        
        if userdefault.bool(forKey: firstLoad) == false {
            self.viewControll.showOnboarding = true
            userdefault.set(true, forKey: firstLoad)
            self.userdefault.set(0.5, forKey: "senceLevel")
            self.PWnum = Int.random(in: 0...2)
            self.userdefault.set(PWnum, forKey: "PWnum")
            parceSounds()
        } else {
            self.soundStack.loadCD()
            self.viewControll.showOnboarding = !apphudHelper.isPremium
            self.soundAnalyzer.senceLevel = userdefault.double(forKey: "senceLevel")
            self.PWnum = userdefault.integer(forKey: "PWnum")
        }
        getProducts()
        getProducts2()
        self.soundStack.soundPlayer.$playingSounds.debounce(for: 0.0, scheduler: RunLoop.main).sink(receiveValue: {_ in
            self.viewControll.showMixeBoard = !self.soundStack.soundPlayer.playingSounds.isEmpty
            
            if self.soundStack.soundPlayer.playingSounds.isEmpty {
                self.viewControll.possitionController = .bottom
            }
        }).store(in: &cancellables)
        
        self.soundAnalyzer.$senceLevel.sink(receiveValue: {val in
            self.userdefault.set(val, forKey: "senceLevel")
        }).store(in: &cancellables)
        
        self.apphudHelper.$isPremium.sink(receiveValue: {val in
            if val {
                self.viewControll.showOnboarding = false
                self.viewControll.showPayWall = false
                self.NCH.del2Hourreqiest()
            }
        }).store(in: &cancellables)
        
    }
    
    func parceSounds(){
        if let url = URL(string: "https://englishforlesson.space/white_noise_3/links/json.structure.txt") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                  if let data = data {
                    do {
                        let newSounds = try JSONDecoder().decode([WhiteSound].self, from: data)
                        self.soundStack.loadInside(sounds: newSounds)
                      } catch let error {
                        print(error)
                      }
                   }
            }.resume()
        }
    }
    
    func getProducts() {
        if let url = URL(string: "https://app.finanse.space/app/snoreApp") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                  if let data = data {
                    do {
                        let payWalls = try JSONDecoder().decode([PayWallText].self, from: data)
                        self.apphudHelper.payWallsText = payWalls
                        self.apphudHelper.choosePWText()
                        print("PW GET")
                      } catch let error {
                        print("Error Dec")
                        print(error)
                      }
                   }
            }.resume()
        }
    }
    
    func getProducts2() {
        if let url = URL(string: "https://app.finanse.space/app/snore2") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                  if let data = data {
                    do {
                        let payWalls = try JSONDecoder().decode([PayWallText2].self, from: data)
                        self.apphudHelper.payWallsText2 = payWalls
                        self.apphudHelper.choosePWText2()
                        print("PW GET 2")
                      } catch let error {
                        print("Error Dec")
                        print(error)
                      }
                   }
            }.resume()
        }
    }
    
}
