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
import ApphudSDK
import SwiftUI

class SoundAnalyzer : ObservableObject {
    @Published var sounds : [Sound] = [Sound]()
    @Published var audioRecorder : AudioRecorder
    @Published var senceLevel : Double
    @Published var filter : Bool = false
    var soundPlayer : WaveSoundPlayer = WaveSoundPlayer(sounds: [Sound]())
    
    // DELEAY LAUNCH
    @Published var timeToDelete : Double = 0.0
    @Published var delayType : DelayTypes?
    var timer : Timer?
    
    var CDH : WaveSoundCDH = WaveSoundCDH()
    var cancellables = Set<AnyCancellable>()
    


    init() {
        self.audioRecorder = AudioRecorder()
        self.senceLevel = 0.5
        self.sounds.append(contentsOf: CDH.loadSounds())
//        self.sounds.append(contentsOf: Sound.data)
        self.sounds.sort(by: {$0.started > $1.started})
        
        for sound in sounds{
            sound.$waves.dropFirst().sink(receiveValue: {val in
                if sound.waves.count != val.count {
                    self.CDH.saveSound(sound)
                }
            }).store(in: &cancellables)
        }
        
        self.soundPlayer = WaveSoundPlayer(sounds: self.sounds)
//        let session = AVAudioSession.sharedInstance()
//        
//        do {
//            try session.setCategory(AVAudioSession.Category.playback, mode: .default, policy: AVAudioSession.RouteSharingPolicy.longFormAudio, options: [])
//        } catch let error {
//            fatalError("*** Unable to set up the audio session: \(error.localizedDescription) ***")
//        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            if let self = self{
                if self.delayType != nil {
                    self.timeToDelete += 1
                    if self.timeToDelete >= self.delayType!.length && !self.audioRecorder.isRecording {
                        self.startRecording()
                    }
                } else {
                    self.timeToDelete = 0
                }
            }
        }
    }
    
    func analiseSound(count: Int, fileName : URL, sound: Sound, group : DispatchGroup? = nil){
        print("analiseSound")
        let audioURL = fileName
        
        let waveformAnalyzer = WaveformAnalyzer(audioAssetURL: audioURL)
    
        if waveformAnalyzer != nil {
            waveformAnalyzer!.samples(count: count) { samples in
                
                if samples != nil {
                    sound.addSamples(samples: samples!, level: self.senceLevel)
                }
                group?.leave()
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
    
    func setLevel(level : Double){
        self.senceLevel = level
        
        DispatchQueue.main.async {
            for sound in self.sounds {
                sound.recolor(level: level)
            }
        }
    }
    
    
    func stopRecording(){
        self.audioRecorder.isRecording = false
        audioRecorder.finishRecording(success: true)
        
        let fileName = audioRecorder.audioFilename
        
        let length = audioRecorder.dateStartRecording != nil && audioRecorder.dateStopRecording != nil ? audioRecorder.dateStopRecording!.timeIntervalSinceReferenceDate - audioRecorder.dateStartRecording!.timeIntervalSinceReferenceDate : 0
        let newSound = Sound(id: UUID(), samples: [Float](), timeInBed: 1, started: audioRecorder.dateStartRecording ?? Date(), stoped: audioRecorder.dateStopRecording ?? Date(), fileName: audioRecorder.fileName!, inDayCound: getTodaysCount(), soundDuration: length)
        
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
        
        if !filter {
            if fileName != nil {
                self.analiseSound(count: 200, fileName: fileName!, sound: newSound)
            } else {
               print("fileName nil")
            }
        } else {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let url = documentDirectory.appendingPathComponent(newSound.fileName)
            
            do {
                let avPlayer = try AVAudioPlayer(contentsOf: url)
                
                var parts = Int(avPlayer.duration / 3)
                parts = parts > 0 ? parts : 1
                
                let group = DispatchGroup()
                
                if fileName != nil {
                    group.enter()
                    self.analiseSound(count: parts, fileName: fileName!, sound: newSound, group: group)
                    
                    group.notify(queue: DispatchQueue.main){
                        print("newSound count \(newSound.waves.count)")
                        let asset: AVAsset = AVAsset(url: url)
                        
                        var toFileParts : [Int] = [Int]()
                        
                        for i in 0..<newSound.waves.count {
                            if newSound.waves[i].color == .Yellow || newSound.waves[i].color == .Red {
                                toFileParts.append(i)
                            }
                            print(newSound.waves[i].color)
                        }
                        print("toFileParts \(toFileParts)")
                        
                        if toFileParts.isEmpty {
                            return
                        }
                        
                        var urls : [URL] = [URL]()
                        let queque = DispatchQueue(label: "asyncQueue", attributes: .concurrent)
                        
                        queque.async {
                            var sessions : [AVAssetExportSession] = [AVAssetExportSession]()
                            
                            let queue = OperationQueue()
                            queue.maxConcurrentOperationCount = 5
                            
                            
                            for i in toFileParts {
                                let newURL = self.getDocumentsDirectory().appendingPathComponent("segment\(i)\(UUID().uuidString).m4a")
                                urls.append(newURL)
                                sessions.append(self.getAudioSplitter(asset: asset, startTime: 3 * i, endTime: 3 * (i + 1), fileName: newURL))
                            }
                            
                            for session in sessions {
                                let operation = SoundCutOperation(task: session)
                                queue.addOperation(operation)
                            }
                            queue.waitUntilAllOperationsAreFinished()
                                
                            
                            let group2 = DispatchGroup()
                            
                            let newFileName = "filter\(UUID().uuidString).m4a"
                            let newFileURL = self.getDocumentsDirectory().appendingPathComponent(newFileName)
                            print(newFileURL)
                            self.mergeAudioFiles(audioFileUrls: urls, fileName: newFileURL, group: group2)
                            print("True Finish")
                            newSound.fileName = newFileName
                            newSound.soundDuration = Double(3 * toFileParts.count)
                            self.analiseSound(count: 200, fileName: newFileURL, sound: newSound)
                            self.CDH.saveSound(newSound)
                        }
                        
                    }
                } else {
                   print("fileName nil")
                }
                
            } catch {
                print("Error with sound")
                print(error)
            }
        }
    }
    
    func splitAudio(asset: AVAsset, startTime : Int, endTime: Int, fileName : URL) {
        print("Start split")
        let duration = CMTimeGetSeconds(asset.duration)
        
        // Create a new AVAssetExportSession
        let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)!
        // Set the output file type to m4a
        exporter.outputFileType = AVFileType.m4a
        // Create our time range for exporting
        let startTime = CMTimeMake(value: Int64(startTime), timescale: 1)
        let maxTime : Int = endTime < Int(duration) ? endTime : Int(duration)
        let endTime = CMTimeMake(value: Int64(maxTime), timescale: 1)
        // Set the time range for our export session
        exporter.timeRange = CMTimeRangeFromTimeToTime(start: startTime, end: endTime)
        // Set the output file path

        let fileNameFull = fileName
        exporter.outputURL = fileNameFull
        
        // Do the actual exporting
        exporter.exportAsynchronously(completionHandler: {
            switch exporter.status {
                case AVAssetExportSession.Status.failed:
                    print("Export failed.")
                default:
                    print("Export complete.")
            }
        })
    }
    
    func getAudioSplitter(asset: AVAsset, startTime : Int, endTime: Int, fileName : URL) ->  AVAssetExportSession {
        print("Start split")
        let duration = CMTimeGetSeconds(asset.duration)
        
        // Create a new AVAssetExportSession
        let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)!
        // Set the output file type to m4a
        exporter.outputFileType = AVFileType.m4a
        // Create our time range for exporting
        let startTime = CMTimeMake(value: Int64(startTime), timescale: 1)
        let maxTime : Int = endTime < Int(duration) ? endTime : Int(duration)
        let endTime = CMTimeMake(value: Int64(maxTime), timescale: 1)
        // Set the time range for our export session
        exporter.timeRange = CMTimeRangeFromTimeToTime(start: startTime, end: endTime)
        // Set the output file path

        let fileNameFull = fileName
        exporter.outputURL = fileNameFull
        return exporter
    }
    
    var mergeAudioURL : URL?
    
    func mergeAudioFiles(audioFileUrls: [URL], fileName: URL, group : DispatchGroup? = nil) {
        print("Start Merge: audioFileUrls \(audioFileUrls.count)")
        let composition = AVMutableComposition()

        for i in 0 ..< audioFileUrls.count {

            let compositionAudioTrack :AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())!
            print("mergeAudioFiles 1 \(i)")
            let asset = AVURLAsset(url: audioFileUrls[i])

            let track = asset.tracks(withMediaType: AVMediaType.audio)[0]

            let timeRange = CMTimeRange(start: CMTimeMake(value: 0, timescale: 600), duration: track.timeRange.duration)

            try! compositionAudioTrack.insertTimeRange(timeRange, of: track, at: composition.duration)
        }

        self.mergeAudioURL = fileName // getDocumentsDirectory().appendingPathComponent("FinalAudio.m4a")

        let group1 = DispatchGroup()
        
        let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)
        assetExport?.outputFileType = AVFileType.m4a
        assetExport?.outputURL = mergeAudioURL!
        group1.enter()
        assetExport?.exportAsynchronously(completionHandler:
            {
                switch assetExport!.status
                {
                case AVAssetExportSession.Status.failed:
                    print("failed export \(assetExport?.error)")
                case AVAssetExportSession.Status.cancelled:
                    print("cancelled \(assetExport?.error)")
                case AVAssetExportSession.Status.unknown:
                    print("unknown\(assetExport?.error)")
                case AVAssetExportSession.Status.waiting:
                    print("waiting\(assetExport?.error)")
                case AVAssetExportSession.Status.exporting:
                    print("exporting\(assetExport?.error)")
                default:
                    print("Audio Concatenation Complete")
                    group1.leave()
                }
        })
        group1.wait()
        print(fileName)
    }
    
    func deleteSound(sound : Sound) {
        let index = sounds.firstIndex(where: {$0.id == sound.id})
        
        if index != nil {
            sounds.remove(at: index!)
        }
        CDH.deleteSound(sound)
    }
    
    
    // Данные графиков
    func getSleepDuration() -> [ChartColumn]{ // 1 /3
        return CalcSoundStaticics.getSleepDuration(self.sounds)
    }
    
    func getGoToBedTime() -> [ChartColumn]{ // 2
        return CalcSoundStaticics.getSleepTime(self.sounds)
    }
    
    func getSnoreScore() -> [ChartColorColumn]{ // 4
        return CalcSoundStaticics.getSnoreScore(self.sounds)
    }
    
    func getSleepQualiti() -> [ChartColumn] { 
        return CalcSoundStaticics.getSleepQualiti(self.sounds)
    }
    
    func getSnoringDuration() -> [ChartColumn] {
        return CalcSoundStaticics.getSnoringDuration(self.sounds)
    }
    
    // Строки
    func getAverageSleepTime() -> String { // 1
        return CalcSoundStaticics.getAverageSleepTime(self.sounds)
    }
    
    
    func delayLaunch(delayType : DelayTypes) {
        if delayType.length != 0 {
            self.delayType = delayType
        } else {
            self.delayType = nil
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
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
