//
//  CoreDataHelper.swift
//  whitesound
//
//  Created by Александр Шендрик on 31.08.2021.
//

import Foundation
import CoreData

class WhiteSoundCDH{
    
    var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "whitesounds")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
    
    var context : NSManagedObjectContext
    
    init() {
        context = persistentContainer.viewContext
        try! context.save()
    }
    
    // WhiteSound
    func saveWhiteSound(_ sound : WhiteSound) {
        let request = WhiteSoundCore.fetchRequest() as NSFetchRequest<WhiteSoundCore>
        let predicate = NSPredicate(format: "fbid == %@", sound.FBid)
        request.predicate = predicate
        
        do{
            let oldSound = try context.fetch(request)
            if !oldSound.isEmpty {
                oldSound[0].fbid = sound.FBid
                oldSound[0].name = sound.name
                oldSound[0].url = sound.url
                oldSound[0].type = sound.type.rawValue
                oldSound[0].imageLink = sound.imageLink
                oldSound[0].imgName = sound.imgName
                oldSound[0].fileName = sound.fileName
                oldSound[0].imgFileName = sound.imgFileName
            } else {
                let newSoundCore = WhiteSoundCore(context: context)
                newSoundCore.fbid = sound.FBid
                newSoundCore.name = sound.name
                newSoundCore.url = sound.url
                newSoundCore.type = sound.type.rawValue
                newSoundCore.imageLink = sound.imageLink
                newSoundCore.imgName = sound.imgName
                newSoundCore.fileName = sound.fileName
                newSoundCore.imgFileName = sound.imgFileName
            }
            
        } catch {
            print(error)
        }
        
        do {
             try context.save()
        } catch {
            print(error)
        }
    }
    
    func saveWhiteSounds(_ sounds : [WhiteSound]) {
        for sound in sounds {
            saveWhiteSound(sound)
        }
    }
    
    func loadAllWhiteSound() -> [WhiteSound] {
        let request = WhiteSoundCore.fetchRequest() as NSFetchRequest<WhiteSoundCore>
        let soundsCore = try! context.fetch(request)
        
        var outSounds = [WhiteSound]()
        for soundCore in soundsCore{
            let soundType = SoundType(rawValue: soundCore.type ?? "All") ?? SoundType.All
            let newSound = WhiteSound(FBid : soundCore.fbid ?? "", name : soundCore.name ?? "", url : soundCore.url ?? "" , fileName : soundCore.fileName, type : soundType, imgName : soundCore.imgName ?? "noimage", imgFileName : soundCore.imgFileName, imageLink: soundCore.imageLink ?? "")
            outSounds.append(newSound)
            
        }
            
        return outSounds
    }
    
    // Mixes
    func saveMixe(_ mixe : Mixe) {
        let request = MixeCore.fetchRequest() as NSFetchRequest<MixeCore>
        let predicate = NSPredicate(format: "id == %@", mixe.id as CVarArg)
        request.predicate = predicate
        
        let oldMixe = try! context.fetch(request)
        
        if !oldMixe.isEmpty {
            oldMixe[0].name = mixe.name
            oldMixe[0].type = mixe.type.rawValue
            oldMixe[0].imageLink = mixe.imageLink
            oldMixe[0].imageFileName = mixe.imageFileName
            
            let request = MixSoundCore.fetchRequest() as NSFetchRequest<MixSoundCore>
            request.relationshipKeyPathsForPrefetching = ["mixeCore"]
            request.predicate = NSPredicate(format: "mixeCore == %@", oldMixe[0])
            
            let oldMixSoundsCore : [MixSoundCore] = try! context.fetch(request)
            
            for sound in mixe.sounds{
                let oldMixSoundCore = oldMixSoundsCore.first(where: {$0.soundID == sound.soundID})
                
                if oldMixSoundCore != nil {
                    oldMixSoundCore!.volume = sound.volume
                } else {
                    let newMixSoundCore = MixSoundCore(context: context)
                    newMixSoundCore.mixeCore = oldMixe[0]
                    newMixSoundCore.possition = Int64(sound.possition)
                    newMixSoundCore.volume = sound.volume
                }
            }
        } else {
            let newMixe = MixeCore(context: context)
            newMixe.id = mixe.id
            newMixe.name = mixe.name
            newMixe.type = mixe.type.rawValue
            newMixe.imageLink = mixe.imageLink
            newMixe.imageFileName = mixe.imageFileName
            
            for sound in mixe.sounds {
                let newMixSoundCore = MixSoundCore(context: context)
                newMixSoundCore.mixeCore = newMixe
                newMixSoundCore.possition = Int64(sound.possition)
                newMixSoundCore.soundID = sound.soundID
                newMixSoundCore.volume = sound.volume
            }
        }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func saveMixes(_ mixes : [Mixe]) {
        for mixe in mixes {
            saveMixe(mixe)
        }
    }
    
    func removeMixe(_ mixe : Mixe) {
        let request = MixeCore.fetchRequest() as NSFetchRequest<MixeCore>
        let predicate = NSPredicate(format: "id == %@", mixe.id as CVarArg)
        request.predicate = predicate
        
        let oldMixeCore = try! context.fetch(request)
        for mixeCore in oldMixeCore{
            context.delete(mixeCore)
        }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func loadAllMixes() -> [Mixe] {
        let request = MixeCore.fetchRequest() as NSFetchRequest<MixeCore>
        let mixesCore = try! context.fetch(request)
        
        var outMixes : [Mixe] = [Mixe]()
        
        for mixeCore in mixesCore {
            var newMixSounds : [MixeSound] = [MixeSound]()
            
            let request = MixSoundCore.fetchRequest() as NSFetchRequest<MixSoundCore>
            request.relationshipKeyPathsForPrefetching = ["mixeCore"]
            request.predicate = NSPredicate(format: "mixeCore == %@", mixeCore)
            
            let oldMixSoundsCore : [MixSoundCore] = try! context.fetch(request)
            
            for oldMixSoundCore in oldMixSoundsCore {
                let newMixSound = MixeSound(soundID: oldMixSoundCore.soundID ?? "", volume: oldMixSoundCore.volume , possition: Int(oldMixSoundCore.possition))
                newMixSounds.append(newMixSound)
            }
            
            let newMixe = Mixe(id: mixeCore.id ?? UUID(), sounds: newMixSounds.sorted(by: {$0.possition < $1.possition}), name: mixeCore.name ?? "", type: MixeType(rawValue: mixeCore.type ?? "All") ?? .All, imageLink: mixeCore.imageLink, imageFileName: mixeCore.imageFileName)
            outMixes.append(newMixe)
        }
        
        return outMixes
    }
    
    // LikedMixes
    
    func saveLikedMixe(_ mixe : Mixe) {
        let request = LikedMixeCore.fetchRequest() as NSFetchRequest<LikedMixeCore>
        let predicate = NSPredicate(format: "mixeId == %@", mixe.id.uuidString)
        request.predicate = predicate
        
        do{
            let oldLikedMixe = try! context.fetch(request)
            if oldLikedMixe.isEmpty {
                let newLikedMixe = LikedMixeCore(context: context)
                newLikedMixe.mixeId = mixe.id.uuidString
            }
        } catch {
            print(error)
        }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    func saveLikedMixes(_ mixes : [Mixe]) {
        for mixe in mixes {
            self.saveLikedMixe(mixe)
        }
    }
    
    func removeLikedMixe(_ mixe : Mixe) {
        let request = LikedMixeCore.fetchRequest() as NSFetchRequest<LikedMixeCore>
        let predicate = NSPredicate(format: "mixeId == %@", mixe.id.uuidString)
        request.predicate = predicate
        
        let oldLikedMixes = try! context.fetch(request)
        for oldLikedMixe in oldLikedMixes{
            context.delete(oldLikedMixe)
        }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func loadAllLikedMixes() -> [String] {
        let request = LikedMixeCore.fetchRequest() as NSFetchRequest<LikedMixeCore>
        let oldLikedMixes = try! context.fetch(request)
        let outIds : [String] = oldLikedMixes.map({$0.mixeId ?? ""})
        return outIds
    }
    
}
