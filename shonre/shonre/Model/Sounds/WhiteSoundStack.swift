//
//  WhiteSoundStack.swift
//  whitesound
//
//  Created by Александр Шендрик on 31.08.2021.
//

import Foundation
import Combine


class WhiteSoundStack: ObservableObject {
    @Published var sounds : [WhiteSound] = [WhiteSound]()
    @Published var soundVM : WhiteSoundVM = WhiteSoundVM(sounds: [WhiteSound]())
    @Published var soundPlayer = SoundPlayer()
    @Published var mixeStack : MixeStack
    @Published var likedMixes : [String] = [String]()
    
    
    // Утилитарные
    var cancellables = Set<AnyCancellable>()
    var CDHelper : WhiteSoundCDH = WhiteSoundCDH()

    
    init() {
        let mixes = CDHelper.loadAllMixes()
        self.mixeStack = MixeStack(mixes: mixes, CDHelper: CDHelper)
        
    }
    
    // Загружаем аудио из Core Data
    func loadCD() {
        self.sounds = CDHelper.loadAllWhiteSound()
        soundVM.allSounds = self.sounds
        likedMixes = CDHelper.loadAllLikedMixes()
        soundVM.reset()
        setCombine()
        loadAll()
    }
    
    // Загружаем аудио с парсинга
    func loadInside(sounds: [WhiteSound]){
        self.sounds = sounds.shuffled()
        CDHelper.saveWhiteSounds(self.sounds)
        soundVM.allSounds = self.sounds
        soundVM.reset()
        setCombine()
        loadAll()
    }
    
    // Сетим Реактивную модель
    private func setCombine(){
        for sound in self.sounds{
            sound.$isPlaying.sink(receiveValue: {val in
                if val {
                    self.soundPlayer.addSound(sound: sound)
                } else{
                    self.soundPlayer.delSound(sound: sound)
                }
            }).store(in: &cancellables)
        }
    }
    
    
    private func loadAll(){
        let toLoadImages = sounds.compactMap({toLoadImage($0)})
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        for sound in toLoadImages {
            let link = URL(string: sound.imageLink)
            if link != nil {
                let operation = DownloadOperation(session: URLSession.shared, downloadTaskURL: link!, completionHandler: { (imageTempFileUrl, response, error) in
                    let fileName = "img\(sound.FBid).jpeg"
                    let fileNameFull = documentDirectory.appendingPathComponent(fileName)
                    if let imageTempFileUrl = imageTempFileUrl {
                        do {
                            // Сохранение загруженой картинки
                            let imageData = try Data(contentsOf: imageTempFileUrl)
                            try imageData.write(to: fileNameFull)
                            sound.imgFileName = fileName
                            sound.uiImage = sound.getImage()
                            self.CDHelper.saveWhiteSound(sound)
                            
                            print("Save Image \(fileName)")
                        } catch {
                            print("Error \(sound.imgFileName)")
                        }
                    }
                })
                queue.addOperation(operation)
            } else {
                print(sound.FBid)
            }
        }
        
        let toLoadAudio = sounds.compactMap({getToLoadAudio($0)})
        
        let queue1 = OperationQueue()
        queue1.maxConcurrentOperationCount = 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for sound in toLoadAudio {
                let operation = DownloadOperation(session: URLSession.shared, downloadTaskURL: URL(string: sound.url)!, completionHandler: { (audioTempFileUrl, response, error) in
                    let fileName = "audio\(sound.FBid).mp3"
                    let fileNameFull = documentDirectory.appendingPathComponent(fileName)
                    if let audioTempFileUrl = audioTempFileUrl {
                        do {
                            // Сохранение загруженого аудио
                            let audioData = try Data(contentsOf: audioTempFileUrl)
                            try audioData.write(to: fileNameFull)
                            sound.fileName = fileName
                            
                            print("Save Audio \(sound.fileName!)")
                        } catch {
                            print("Error \(sound.fileName)")
                        }
                    }
                })
                queue1.addOperation(operation)
            }
        }
        
        // Пишем путь приложения в файлах в консуль - только для дебага
        print("PATH")
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.applicationSupportDirectory, .userDomainMask, true)
        print("Preview in: \(paths)")
    }
    
    private func toLoadImage(_ sound : WhiteSound) -> WhiteSound? {
        if sound.imgFileName == nil {
            return sound
        } else {
            return nil
        }
    }
    
    private func getToLoadAudio(_ sound : WhiteSound) -> WhiteSound? {
        if sound.fileName == nil {
            return sound
        } else {
            return nil
        }
    }

    // Добавляем или обновляем микс
    func saveMixe(toPublic : Bool) {
        var newMixe = soundPlayer.getCurrentPlayingMixe()
        self.mixeStack.updateMixe(newMixe)
        newMixe.likes = 1
        
        CDHelper.saveMixe(newMixe)
    }
    
    // Играем микс
    func playMixe(_ mixe : Mixe)
    {
        for sound in self.soundPlayer.playingSounds.map({$0.sound}) {
            sound.isPlaying = false
        }
        
        for mixeSound in mixe.sounds {
            let soundToPlay = self.sounds.first(where: {$0.FBid == mixeSound.soundID})
            soundToPlay?.isPlaying = true
        }
        
        self.soundPlayer.mixeID = mixe.id
    }
    
    func getMixeSounds(_ mixe : Mixe) -> [WhiteSound] {
        var outMixes = [WhiteSound]()
        
        for mixeSound in mixe.sounds {
            let soundToShow = self.sounds.first(where: {$0.FBid == mixeSound.soundID})
            if soundToShow != nil {
                outMixes.append(soundToShow!)
            }
        }
        return outMixes
    }
    
    // Получаем звуки из Миксов
    func getSound(for mixeSound : MixeSound ) -> WhiteSound? {
        return self.sounds.first(where: {$0.FBid == mixeSound.soundID})
    }
    

    
    func getSounds(for mixe : Mixe) -> [WhiteSound] {
        var outSounds = [WhiteSound]()
        
        for mixeSound in mixe.sounds {
            let outSound = getSound(for: mixeSound)
            if outSound != nil {
                outSounds.append(outSound!)
            }
        }
        
        return outSounds
    }
    
    func getSoundNames(for mixe : Mixe) -> String {
        var outNames = ""
        
        for mixeSound in mixe.sounds {
            let sound = getSound(for: mixeSound)
            
            if sound != nil {
                outNames += sound!.name + ", "
            }
        }
        
        return String(outNames.dropLast().dropLast())
    }
    
    func deleteMixe(_ mixe : Mixe) {
        let index = self.mixeStack.mixes.firstIndex(where: {$0.id == mixe.id})
        
        if index != nil {
            print("deleteMixe \(index!)")
            self.mixeStack.mixes.remove(at: index!)
        }
        CDHelper.removeMixe(mixe)
    }
    
    func likeMixe(_ mixe : Mixe) {
        
        mixe.liked = true
        
        mixe.likes += 1
        self.likedMixes.append(mixe.id.uuidString)
        CDHelper.saveLikedMixe(mixe)
//        try! docRef.setData(from: newMixe)
        

    }
    
    func dislikeMixe(_ mixe : Mixe) {
        let index = self.likedMixes.firstIndex(where: {$0 == mixe.id.uuidString})
        mixe.liked = false
        if index != nil {
            mixe.likes -= 1
            self.likedMixes.remove(at: index!)
            CDHelper.removeMixe(mixe)
        }
    }
}
