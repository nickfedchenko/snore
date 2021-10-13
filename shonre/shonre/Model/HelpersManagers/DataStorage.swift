//
//  DataStorage.swift
//  shonre
//
//  Created by Александр Шендрик on 01.10.2021.
//

import Foundation
import Combine

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
        self.soundAnalyzer = SoundAnalyzer()
        self.soundStack = WhiteSoundStack()
        
        if userdefault.bool(forKey: firstLoad) == false {
            self.viewControll.showOnboarding = true
            userdefault.set(true, forKey: firstLoad)
            parceSounds()
            
        } else {
            self.soundStack.loadCD()
        }
        
        self.soundStack.soundPlayer.$playingSounds.debounce(for: 0.0, scheduler: RunLoop.main).sink(receiveValue: {_ in
            self.viewControll.showMixeBoard = !self.soundStack.soundPlayer.playingSounds.isEmpty
            
            if self.soundStack.soundPlayer.playingSounds.isEmpty {
                self.viewControll.possitionController = .bottom
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
    
}
