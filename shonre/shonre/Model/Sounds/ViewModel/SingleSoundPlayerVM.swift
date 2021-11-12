//
//  SingleSoundPlayerVW.swift
//  whitesound
//
//  Created by Александр Шендрик on 06.09.2021.
//

import Foundation
import AVFoundation
import AVKit
import Combine

class SingleSoundPlayerVM: ObservableObject {
    var id : UUID = UUID()
    @Published var sound : WhiteSound
    @Published var avPlayer : AVAudioPlayer?
    
    var cancellables = Set<AnyCancellable>()
    var incideCancellables = [AnyCancellable]()
    
    
    private var loked : Bool = false
    
    init(_ sound : WhiteSound) {
        self.sound = sound
        setAudio()
        
        sound.$fileName.debounce(for: 0.0, scheduler: RunLoop.main).sink(receiveValue: {_ in
            if self.avPlayer == nil{
                self.setAudio()
            }
        }).store(in: &cancellables)
        
        sound.$isPlaying.sink(receiveValue: {isPlaying in
            if isPlaying && !self.loked {
                self.avPlayer?.play()
            } else {
                self.avPlayer?.pause()
            }
        }).store(in: &cancellables)
        
        sound.$volume.sink(receiveValue: {volume in
            self.avPlayer?.volume = volume
        }).store(in: &cancellables)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
//            self.avPlayer?.play()
//        }
        
    }
    
    func lock() {
        loked = true
        avPlayer?.stop()
        avPlayer = nil
    }
    
    func pausePlay() {
        if !self.loked{
            self.avPlayer?.pause()
        }
    }
    
    func continuePlay() {
        if !self.loked {
            self.avPlayer?.play()
        }
    }
    
    func setAudio(){
        
            if sound.fileName != nil {
                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let url = documentDirectory.appendingPathComponent(sound.fileName!)
                
                do {
                    self.avPlayer = try AVAudioPlayer(contentsOf: url)
                    self.avPlayer?.numberOfLoops = -1
                    self.avPlayer?.prepareToPlay()
                    self.avPlayer?.play()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.avPlayer?.play()
                    }
                    
                } catch {
                    print("Error with sound")
                }
            }
        }
    
    
    func playAtTime(hour: Int, minute: Int) {
        if self.avPlayer != nil && !loked {
            self.avPlayer?.stop()
            let today = Date()
            let calendar = Calendar.current
            let curHour = calendar.component(.hour, from: today)
            
            var addDay = DateComponents()
        
            addDay.day = curHour >= hour ? 1 : 0
            addDay.hour = hour
            addDay.minute = minute
            let startTime = calendar.date(byAdding: addDay, to: calendar.startOfDay(for: today))!
            
            print("Start Play \(startTime)")
            let diffComponents : DateComponents = calendar.dateComponents([.hour, .minute], from: today, to: startTime)
            let hours = diffComponents.hour ?? 0
            let minutes = diffComponents.minute ?? 0
            let timeOffset : TimeInterval = TimeInterval(hours * 3600 + minutes * 60)
            self.avPlayer?.play(atTime: timeOffset)
        }
    }
}
    
    
    

