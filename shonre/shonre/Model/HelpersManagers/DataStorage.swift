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

class DataStorage : ObservableObject {
    
    // Работа с данными
    @Published var soundAnalyzer : SoundAnalyzer
    @Published var soundStack : WhiteSoundStack
    
    // Отображение графики
    @Published var viewControll : ViewControll = ViewControll()
    
    // Работа с окружением
    var apphudHelper : ApphudHelper =  ApphudHelper()
    
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
    
    init() {
        FirebaseApp.configure()
        self.soundAnalyzer = SoundAnalyzer()
        self.soundStack = WhiteSoundStack()
        
        Amplitude.instance().trackingSessionEvents = true
        Amplitude.instance().initializeApiKey("05a7087670a743098b669571309fdae7")
        Amplitude.instance().logEvent("app_start")
        
        if userdefault.bool(forKey: firstLoad) == false {
            self.viewControll.showOnboarding = true
            userdefault.set(true, forKey: firstLoad)
            self.userdefault.set(0.5, forKey: "senceLevel")
            parceSounds()
        } else {
            self.soundStack.loadCD()
            self.viewControll.showOnboarding = !apphudHelper.isPremium
            self.soundAnalyzer.senceLevel = userdefault.double(forKey: "senceLevel")
        }
        
        getProducts()
        
        self.soundStack.soundPlayer.$playingSounds.debounce(for: 0.0, scheduler: RunLoop.main).sink(receiveValue: {_ in
            self.viewControll.showMixeBoard = !self.soundStack.soundPlayer.playingSounds.isEmpty
            
            if self.soundStack.soundPlayer.playingSounds.isEmpty {
                self.viewControll.possitionController = .bottom
            }
        }).store(in: &cancellables)
        
        self.soundAnalyzer.$senceLevel.sink(receiveValue: {val in
            self.userdefault.set(val, forKey: "senceLevel")
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
    
}
