//
//  WhiteSoundGroup.swift
//  whitesound
//
//  Created by Александр Шендрик on 31.08.2021.
//

import Foundation
import Combine
import AVKit

class SoundPlayer: ObservableObject{
    @Published var playingSounds : [SingleSoundPlayerVM] = [SingleSoundPlayerVM]()
    @Published var isPlaying : Bool = true
    @Published var textLabel : String = "0"
    
    
    // Создание нового микса
    @Published var mixeID : UUID?
    @Published var mixeName : String = ""
    @Published var mixeType : MixeTypeList = MixeTypeList(type: .Meditation)
    
    // Запуск по времени
    @Published var playAt : PlayAtTimeVM = PlayAtTimeVM()
    
    // Оставновка воспроизведения
    @Published var stopPlay : StopPlayVM = StopPlayVM()
    
    // Затухание воспроизведения
    @Published var attenuation : AttenuationVM = AttenuationVM()
    
    var cancellables = Set<AnyCancellable>()
    var canDict = [UUID:Set<AnyCancellable>]()
    
    init() {
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSession.Category.playback, mode: .default, policy: AVAudioSession.RouteSharingPolicy.longFormAudio, options: [])
        } catch let error {
            fatalError("*** Unable to set up the audio session: \(error.localizedDescription) ***")
        }
        
        
        $playingSounds.debounce(for: 0.0, scheduler: RunLoop.main).sink(receiveValue: {val in
            self.textLabel = "\(self.playingSounds.count)"
        }).store(in: &cancellables)
        
        attenuation.$percent.sink(receiveValue: { percent in
            for playingSound in self.playingSounds {
                playingSound.avPlayer?.volume = playingSound.sound.volume * percent
            }
        }).store(in: &cancellables)
        
        stopPlay.$isTurnOff.sink(receiveValue: { isTurnOff in
            if isTurnOff {
                self.isPlaying = false
            }
        }).store(in: &cancellables)
        
        playAt.$isOn.sink(receiveValue: { isOn in
            if isOn {
                self.isPlaying =  false
            }
        }).store(in: &cancellables)
        
        
        $isPlaying.debounce(for: 0.0, scheduler: RunLoop.main).sink(receiveValue: { isPlaying in
            if self.isPlaying &&  self.playAt.isOn {
                self.playAt.isOn = false
            }
        }).store(in: &cancellables)
        
    }
    
    func labelText(count : Int) -> String {
        
        let langStr = Locale.current.languageCode
        
        if langStr == "en" {
            if count > 0 {
                if count == 1 {
                    return "1 sound"
                }
                
                if 1 < count {
                    return "\(count) sounds"
                }
            } else {
                return "No sound"
            }
        }
        
        if langStr == "ru" {
            if count > 0 {
                if count == 1 {
                    return "1 звук"
                }
                
                if 1 < count && count < 5 {
                    return "\(count) звука"
                }
                if count > 4 {
                    return "\(count) звуков"
                }
            } else {
                return "Нет звуков"
            }
        }
        
        return "No sound"
        
    }
    
    func addSound(sound : WhiteSound) {
        if !isPlaying {
            isPlaying = true
        }
        let newSound = playingSounds.first(where: {$0.sound.id == sound.id})
        if newSound == nil {
            let newSoundPlay = SingleSoundPlayerVM(sound)
            playingSounds.append(newSoundPlay)
            newSound?.avPlayer?.play()
            
            var newCan = Set<AnyCancellable>()
            $isPlaying.sink(receiveValue: {isPlaying in
                if isPlaying{
                    newSoundPlay.continuePlay()
                } else {
                    newSoundPlay.pausePlay()
                }
            }).store(in: &newCan)
            
            attenuation.$percent.sink(receiveValue: {percent in
                newSoundPlay.avPlayer?.volume = newSoundPlay.sound.volume * percent
            }).store(in: &newCan)
            
            playAt.$isOn.debounce(for: 0.0, scheduler: RunLoop.main).sink(receiveValue: {isOn in
                if isOn {
                    newSoundPlay.playAtTime(hour: self.playAt.hour, minute: self.playAt.minutes)
                } else {
                    newSoundPlay.avPlayer?.stop()
                }
            }).store(in: &newCan)
            
            self.canDict.updateValue(newCan, forKey: newSoundPlay.sound.id)
        }
    }
    
    func delSound(sound : WhiteSound) {
        let allToDell = playingSounds.filter({$0.sound.id == sound.id})
        
        for toDellSound in allToDell {
            let soundIndex = playingSounds.firstIndex(where: {$0.sound.id == toDellSound.sound.id})
            
            if soundIndex != nil {
                playingSounds.remove(at: soundIndex!)
                self.canDict.removeValue(forKey: toDellSound.sound.id)
            }
        }
    }
    
    func getCurrentPlayingMixe() -> Mixe {
        var nexMixSounds = [MixeSound]()
        
        var count = 0
        for sound in self.playingSounds.map({$0.sound}) {
            let nexMixSound = MixeSound(soundID: sound.FBid, volume: sound.volume, possition: count)
            count += 1
            nexMixSounds.append(nexMixSound)
        }
        mixeID = UUID()
        return Mixe(id: mixeID!, sounds: nexMixSounds, name: self.mixeName, type: self.mixeType.type, imageLink: nil, imageFileName: nil)
    }
    
    func resetTime() {
        for sound in self.playingSounds {
            sound.avPlayer!.currentTime = 0.0
            sound.avPlayer!.play()
        }
    }
    
    
}
