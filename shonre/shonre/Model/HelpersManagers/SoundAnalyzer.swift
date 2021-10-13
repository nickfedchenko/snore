//
//  SoundAnalyzer.swift
//  shonre
//
//  Created by Александр Шендрик on 05.10.2021.
//

import Foundation
import DSWaveformImage
import AVKit
import Combine

class SoundAnalyzer : ObservableObject {
    @Published var sounds : [Sound] = [Sound]()
    @Published var audioRecorder : AudioRecorder
    var soundPlayer : WaveSoundPlayer = WaveSoundPlayer(sounds: [Sound]())
    
    var CDH : WaveSoundCDH = WaveSoundCDH()
    var cancellables = Set<AnyCancellable>()

    init() {
        self.audioRecorder = AudioRecorder()
        self.sounds.append(contentsOf: CDH.loadSounds())
        self.sounds.append(contentsOf: Sound.data)
        self.sounds.sort(by: {$0.started > $1.started})
        
        for sound in sounds{
            sound.$waves.dropFirst().sink(receiveValue: {val in
                if sound.waves.count != val.count {
                    self.CDH.saveSound(sound)
                }
            }).store(in: &cancellables)
        }
        
        self.soundPlayer = WaveSoundPlayer(sounds: self.sounds)
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSession.Category.playback, mode: .default, policy: AVAudioSession.RouteSharingPolicy.longFormAudio, options: [])
        } catch let error {
            fatalError("*** Unable to set up the audio session: \(error.localizedDescription) ***")
        }
    }
    
    func analiseSound(count: Int, fileName : URL, sound: Sound){
        print("analiseSound")
        let audioURL = fileName
        
        let waveformAnalyzer = WaveformAnalyzer(audioAssetURL: audioURL)
    
        if waveformAnalyzer != nil {
            waveformAnalyzer!.samples(count: count) { samples in
                
                if samples != nil {
                    sound.addSamples(samples: samples!)
                }
            }
        }
    }
    
    func startRecording(){
        self.audioRecorder.isRecording = true
        audioRecorder.startRecording()
        print("startRecording")
    }
    
    func getTodaysCount() -> Int {
        let today = Date()
        let calendar = Calendar.current
        
        var count = 0
        for sound in self.sounds {
            
            if calendar.numberOfDaysBetween(sound.started, and: today) == 1 {
                count += 1
            }
        }
        
        return count + 1
    }
    
    func stopRecording(){
        self.audioRecorder.isRecording = false
        audioRecorder.finishRecording(success: true)
        
        let fileName = audioRecorder.audioFilename
        
        let newSound = Sound(id: UUID(), samples: [Float](), timeInBed: 1, started: audioRecorder.dateStartRecording ?? Date(), stoped: audioRecorder.dateStopRecording ?? Date(), fileName: audioRecorder.fileName!, inDayCound: getTodaysCount())
        
        audioRecorder.dateStartRecording = nil
        audioRecorder.dateStopRecording = nil
        audioRecorder.fileName = nil
        
        print("CDH 1 start")
        CDH.saveSound(newSound)
        print("CDH 1 susses")
        
        self.sounds.append(newSound)
        self.soundPlayer.addSound(newSound)
        self.sounds.sort(by: {$0.started > $1.started})
        
        newSound.$waves.debounce(for: 0.0, scheduler: RunLoop.main).sink(receiveValue: {val in
            self.CDH.saveSound(newSound)
        }).store(in: &cancellables)
        
        if fileName != nil {
            self.analiseSound(count: 200, fileName: fileName!, sound: newSound)
        } else {
           print("fileName nil")
        }
    }
    
    func deleteSound(sound : Sound) {
        let index = sounds.firstIndex(where: {$0.id == sound.id})
        
        if index != nil {
            sounds.remove(at: index!)
        }
        CDH.deleteSound(sound)
    }
    
    
    func getSleepDuration() -> [ChartColumn]{
        return CalcSoundStaticics.getSleepDuration(self.sounds)
    }
    
    func getSleepTime() -> [ChartColumn]{
        return CalcSoundStaticics.getSleepTime(self.sounds)
    }
    
    func getSnoreScore() -> [ChartColorColumn]{
        return CalcSoundStaticics.getSnoreScore(self.sounds)
    }
    
    func getAverageSleepTime() -> String {
        return CalcSoundStaticics.getAverageSleepTime(self.sounds)
    }
}

extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from)
        let toDate = startOfDay(for: to)
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)
        
        return numberOfDays.day! + 1 // <1>
    }
}
