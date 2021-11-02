//
//  att.swift
//  whitesound
//
//  Created by Александр Шендрик on 06.09.2021.
//

import Foundation
import Combine

class AttenuationVM: ObservableObject {
    @Published var isOn : Bool = false
    @Published var startsOn : Float = 60 * 10
    @Published var textLabel : String = "10 min."
    @Published var textLabel2 : String = "00:00"
    @Published var percent : Float = 1.0
    
    //Счёт времени
    @Published var currentTime : Float = 0.0
    var timer : Timer?
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        
        $startsOn.sink(receiveValue: {val in
            self.textLabel = self.getTextLabel(val)
            self.textLabel2 = self.getText2(0)
        }).store(in: &cancellables)
        
        
        $isOn.sink(receiveValue: {isOn in
            if !isOn {
                self.percent = 1.0
                self.currentTime = 0.0
                self.textLabel2 = self.getText2(0)
            }
        }).store(in: &cancellables)
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] timer in
            if let self = self{
                if self.isOn {
                    self.currentTime += 0.5
                    if self.currentTime >= self.startsOn {
                        self.percent -= 1.0 / (60 * 3 * 2)
                        self.textLabel2 = self.getText2(180 - (self.currentTime - self.startsOn))
                        if self.percent < 0 {
                            self.percent = 0
                            self.textLabel2 = self.getText2(0)
                        }
                    }
                }
            }
        }
    }
    
    func getTextLabel(_ val : Float) -> String {
        let min : Int = Int(val / 60)
        
        let langStr = Locale.current.languageCode
        if langStr == "en" {
            return val > 9 ? "\(min) min." : "0\(min) min."
        }
        if langStr == "ru" {
            return val > 9 ? "\(min) мин." : "0\(min) мин."
        }
        
        return val > 9 ? "\(min) мин." : "0\(min) мин."
    }
    
    func getText2(_ val : Float) -> String {
        let min : Int = Int(val / 60)
        let sec : Int = Int(val) % 60
        
        return (min > 9 ? "\(min)" : "0\(min)") + ":" + (sec > 9 ? "\(sec)" : "0\(sec)")
    }
    
}
