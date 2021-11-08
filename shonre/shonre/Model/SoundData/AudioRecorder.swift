//
//  AdudioRecorder.swift
//  shonre
//
//  Created by Александр Шендрик on 06.10.2021.
//

import Foundation
import AVFoundation

class AudioRecorder : NSObject, AVAudioRecorderDelegate, ObservableObject {
    
    var audioRecorder: AVAudioRecorder?
    
    var audioFilename : URL?
    @Published var isRecording : Bool = false
    
    var dateStartRecording : Date?
    var dateStopRecording : Date?
    var fileName : String?
    
    override init() {
        super.init()
    }
    
    func startRecording() {
        self.fileName = UUID().uuidString + ".m4a"
        self.audioFilename = getDocumentsDirectory().appendingPathComponent(self.fileName!)
        print("audioFilename")
        print(self.audioFilename!)
        self.dateStartRecording = Date()
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord)
            try recordingSession.setActive(true, options: .notifyOthersOnDeactivation)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print("record allowed")
                    } else {
                        // failed to record!
                        print("failed to record!")
                    }
                }
            }
        } catch {
            // failed to record!
            print("failed to record!")
        }
        
//        do {
            audioRecorder = try! AVAudioRecorder(url: audioFilename!, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.prepareToRecord()
            self.audioRecorder!.record()
            print("start record here")
            print(audioRecorder!.isRecording)
            self.isRecording = true
//        } catch {
//            print("ERROR RECORD!")
//            print(error)
//            finishRecording(success: false)
//        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func finishRecording(success: Bool) {
        print("finishRecording")
        print(audioRecorder!.isRecording)
        audioRecorder?.stop()
        
//        audioRecorder = nil
        self.dateStopRecording = Date()
        
        let fileManager = FileManager.default
        print(audioRecorder!.url.absoluteURL)
        
        let fileNameFull = getDocumentsDirectory().appendingPathComponent(self.fileName!)
        if !fileManager.fileExists(atPath: self.audioFilename!.relativePath) {
            print("file exist")
        } else {
            print("file DOESTN exist")
            print(fileNameFull)
        }
        
        if success {
            self.isRecording = false
        } else {
            self.isRecording = true
            // recording failed :(
        }
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("audioRecorderDidFinishRecording successfully : \(flag)")
        if !flag {
            finishRecording(success: false)
        }
    }
}
