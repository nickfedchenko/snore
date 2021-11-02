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
    @Published var sound : WhiteSound
    @Published var avPlayer : AVAudioPlayer?
    
    var cancellables = Set<AnyCancellable>()
    var incideCancellables = [AnyCancellable]()
    
    init(_ sound : WhiteSound) {
        self.sound = sound
//        let url = Bundle.main.url(forResource: sound.fileName, withExtension: "mp3")
        setAudio()
        
        sound.$fileName.debounce(for: 0.0, scheduler: RunLoop.main).sink(receiveValue: {_ in
            if self.avPlayer == nil{
                self.setAudio()
            }
        }).store(in: &cancellables)
        
        sound.$isPlaying.sink(receiveValue: {isPlaying in
            if self.avPlayer != nil {
                if isPlaying {
                    if !self.avPlayer!.isPlaying{
//                        self.avPlayer?.play()
                    }
                } else {
                    if self.avPlayer!.isPlaying{
                        self.avPlayer?.pause()
                    }
                }
            }
        }).store(in: &cancellables)
        
        sound.$volume.sink(receiveValue: {volume in
            self.avPlayer?.volume = volume
        }).store(in: &cancellables)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.avPlayer?.play()
        }
    }
    
    func pausePlay() {
        self.avPlayer?.pause()
    }
    
    func continuePlay() {
        self.avPlayer?.play()
    }
    
    func setAudio(){
        if sound.fileName != nil {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let url = documentDirectory.appendingPathComponent(sound.fileName!)
            
            do {
                self.avPlayer = try AVAudioPlayer(contentsOf: url)
                self.avPlayer?.numberOfLoops = -1
                self.avPlayer?.prepareToPlay()
                
            } catch {
                print("Error with sound")
            }
        }
    }
    
    func playAtTime(hour: Int, minute: Int) {
        if self.avPlayer != nil{
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
