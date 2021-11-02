//
//  AdudioRecorder.swift
//  shonre
//
//  Created by Александр Шендрик on 06.10.2021.
//

import Foundation
import AVFoundation

class AudioRecorder : NSObject, AVAudioRecorderDelegate, ObservableObject {
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    var audioFilename : URL?
    @Published var isRecording : Bool = false
    
    var dateStartRecording : Date?
    var dateStopRecording : Date?
    var fileName : String?
    
    override init() {
        recordingSession = AVAudioSession.sharedInstance()
        super.init()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        
                    } else {
                        // failed to record!
                        print("failed to record!")
                    }
                }
            }
        } catch {
            // failed to record!
        }
    }
    
    func startRecording() {
        self.fileName = UUID().uuidString + ".m4a"
        let audioFilename = getDocumentsDirectory().appendingPathComponent(self.fileName!)
        self.dateStartRecording = Date()
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            self.audioFilename = audioFilename
            audioRecorder.delegate = self
            audioRecorder.record()

            self.isRecording = true
        } catch {
            finishRecording(success: false)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        self.dateStopRecording = Date()
        
        if success {
            self.isRecording = false
        } else {
            self.isRecording = true
            // recording failed :(
        }
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}
