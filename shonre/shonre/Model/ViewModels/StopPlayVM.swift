//
//  StopPlayVM.swift
//  whitesound
//
//  Created by Александр Шендрик on 11.09.2021.
//

import Foundation
import Combine

class StopPlayVM: ObservableObject {
    @Published var isOn : Bool = false
    @Published var isTurnOff : Bool = false
    @Published var startsOn : Float = 0
    @Published var textLabel : String = "10 мин."
    
    //Данные в компоненты
    @Published var sHours : Int = 0
    @Published var sMinutes : Int = 0
    
    //Счёт времени
    @Published var currentTime : Float = 0.0
    var timer : Timer?
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        textLabel = self.getTextLabel(startsOn)
        $startsOn.sink(receiveValue: {val in
            self.textLabel = self.getTextLabel(val)
        }).store(in: &cancellables)
        
        $isOn.sink(receiveValue: {isOn in
            if !isOn {
                self.currentTime = 0.0
                self.isTurnOff = false
            }
        }).store(in: &cancellables)
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            if let self = self{
                if self.isOn {
                    self.currentTime += 1
                    if self.currentTime >= self.startsOn {
                        if self.startsOn > 0 {
                            self.isTurnOff = true
                            self.sHours = 0
                            self.sMinutes = 0
                        }
                    }
                }
            }
        }
        
        $sHours.debounce(for: 0.0, scheduler: RunLoop.main).sink(receiveValue: {_ in
            self.startsOn = Float(3600 * self.sHours + 60 * self.sMinutes)
            
            if self.startsOn > 0 {
                self.isOn = true
            } else {
                self.isOn = false
            }
        }).store(in: &cancellables)
        
        $sMinutes.debounce(for: 0.0, scheduler: RunLoop.main).sink(receiveValue: {_ in
            self.startsOn = Float(3600 * self.sHours + 60 * self.sMinutes)
            
            if self.startsOn > 0 {
                self.isOn = true
            } else {
                self.isOn = false
            }
        }).store(in: &cancellables)
    }
    
    
    func getTextLabel(_ val : Float) -> String {
        if val > 0 {
            let min : Int = Int(val / 60)
            return val > 9 ? "\(min) мин." : "0\(min) мин."
        } else {
            let langStr = Locale.current.languageCode
            if langStr == "ru" {
                return "Выбрать"
            }
            return "Choose"
        }
    }
}
