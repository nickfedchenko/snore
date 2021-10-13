//
//  WaveSoundPlayer.swift
//  shonre
//
//  Created by Александр Шендрик on 06.10.2021.
//

import Foundation
import AVFoundation
import Combine

class SingleWaveSoundPlayer : ObservableObject, Identifiable {
    var id = UUID()
    var sound : Sound
    
    @Published var avPlayer : AVAudioPlayer?
    @Published var isPlaying : Bool = false
    @Published var timeText : String = "00:00"
    @Published var durationText : String = "00:00"
    
    var cancellables = Set<AnyCancellable>()
    var timer : Timer?
    
    init(sound : Sound){
        self.sound = sound
        setAudio()
        durationText = getFullTime()
        
        $isPlaying.sink(receiveValue: {val in
            if val {
                self.continuePlay()
            } else {
                self.pausePlay()
            }
        }).store(in: &cancellables)
        
    }
    
    func pausePlay() {
        self.avPlayer?.pause()
    }
    
    func continuePlay() {
        self.avPlayer?.play()
    }
    
    func setAudio(){
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documentDirectory.appendingPathComponent(sound.fileName)
        print(documentDirectory.path)
        print(sound.fileName)
        
        do {
            self.avPlayer = try AVAudioPlayer(contentsOf: url)
            self.avPlayer?.numberOfLoops = 0
            self.avPlayer?.prepareToPlay()
            
        } catch {
            print("Error with sound")
            print(error)
        }
    }
    
    func setTime(proggres : Double) {
        if avPlayer != nil {
            avPlayer!.currentTime = Double(avPlayer!.duration) * proggres / 100.0
            avPlayer!.play()
        }
    }
    
    func getProggres() -> Double {
        if avPlayer != nil {
            let dutation : Double = Double(self.avPlayer!.duration)
            let cutTime : Double = Double(avPlayer!.currentTime)
            return cutTime / dutation * 100
        }
        
        return 0.0
    }
    
    func addTime(_ time : Double){
        if avPlayer != nil {
            avPlayer!.currentTime += time
            avPlayer!.play()
        }
    }
    
    func getFullTime() -> String {
        let m : Int = Int(self.sound.length) / 60
        let s : Int = Int(self.sound.length) % 60
        return (m > 9 ? "\(m)" : "0\(m)") + ":" + (s > 9 ? "\(s)" : "0\(s)")
    }
    
    func getCurrentTime() -> String {
        if avPlayer != nil {
            let currentTime : Double = Double(avPlayer!.currentTime)
            let m : Int = Int(currentTime) / 60
            let s : Int = Int(currentTime) % 60
            return (m > 9 ? "\(m)" : "0\(m)") + ":" + (s > 9 ? "\(s)" : "0\(s)")
        }
        return "00:00"
    }
    
}


extension SingleWaveSoundPlayer {
    static var data : [SingleWaveSoundPlayer] = [SingleWaveSoundPlayer(sound: Sound.data[0])]
}
