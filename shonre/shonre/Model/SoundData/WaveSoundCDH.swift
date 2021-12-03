//
//  WaveSoundCDH.swift
//  shonre
//
//  Created by Александр Шендрик on 06.10.2021.
//

import Foundation
import CoreData

class WaveSoundCDH{
    
    var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "WaveSounds")
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
    
    // Sound
    func saveSound(_ sound : Sound){
        let request = SoundCore.fetchRequest() as NSFetchRequest<SoundCore>
        let predicate = NSPredicate(format: "id == %@", sound.id as CVarArg)
        request.predicate = predicate
        
        let oldSound = try! context.fetch(request)
        
        if !oldSound.isEmpty {
            oldSound[0].fileName = sound.fileName
            oldSound[0].length = sound.length
            oldSound[0].started = sound.started
            oldSound[0].stoped = sound.stoped
            oldSound[0].soundDuration = sound.soundDuration
            oldSound[0].timeInBed = sound.timeInBed
            oldSound[0].timeNoSnoring = sound.timeNoSnoring
            oldSound[0].timeSnoringRed = sound.timeSnoringRed
            oldSound[0].timeSnoringYellow = sound.timeSnoringYellow
            oldSound[0].inDayCound = Int64(sound.inDayCound)
            
            let request = SingleWaveCore.fetchRequest() as NSFetchRequest<SingleWaveCore>
            request.relationshipKeyPathsForPrefetching = ["mixeCore"]
            request.predicate = NSPredicate(format: "sound == %@", oldSound[0])
            
            let oldSingleWavesCore : [SingleWaveCore] = try! context.fetch(request)
            
            for wave in sound.waves{
                let oldSingleWaveCore = oldSingleWavesCore.first(where: {$0.id == sound.id})
                
                if oldSingleWaveCore != nil {
                    oldSingleWaveCore!.number = Int64(wave.number)
                    oldSingleWaveCore!.volume = wave.volume
                    oldSingleWaveCore!.color = wave.color.rawValue
                } else {
                    let newSingleWaveCore = SingleWaveCore(context: context)
                    newSingleWaveCore.id = wave.id
                    newSingleWaveCore.number = Int64(wave.number)
                    newSingleWaveCore.volume = wave.volume
                    newSingleWaveCore.color = wave.color.rawValue
                    newSingleWaveCore.sound = oldSound[0]
                }
            }
            
        } else {
            let newSound = SoundCore(context: context)
            newSound.id = sound.id
            newSound.fileName = sound.fileName
            newSound.length = sound.length
            newSound.started = sound.started
            newSound.stoped = sound.stoped
            newSound.soundDuration = sound.soundDuration
            newSound.timeInBed = sound.timeInBed
            newSound.timeNoSnoring = sound.timeNoSnoring
            newSound.timeSnoringRed = sound.timeSnoringRed
            newSound.timeSnoringYellow = sound.timeSnoringYellow
            newSound.inDayCound = Int64(sound.inDayCound)
            
            
            for wave in sound.waves{
                let newSingleWaveCore = SingleWaveCore(context: context)
                newSingleWaveCore.id = wave.id
                newSingleWaveCore.number = Int64(wave.number)
                newSingleWaveCore.volume = wave.volume
                newSingleWaveCore.color = wave.color.rawValue
                newSingleWaveCore.sound = newSound
            }
            print("sound.waves \(sound.waves.count)")
        }
        
        do {
             try context.save()
        } catch {
            print(error)
        }
    }
    
    func saveSounds(_ sounds : [Sound]){
        for sound in sounds {
            self.saveSound(sound)
        }
    }
    
    func deleteSound(_ sound : Sound){
        let request = SoundCore.fetchRequest() as NSFetchRequest<SoundCore>
        let predicate = NSPredicate(format: "id == %@", sound.id as CVarArg)
        request.predicate = predicate
        
        let oldSoundCore = try! context.fetch(request)
        for soundCore in oldSoundCore{
            context.delete(soundCore)
        }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }

    func loadSounds() -> [Sound] {
        let request = SoundCore.fetchRequest() as NSFetchRequest<SoundCore>
        let soundsCore = try! context.fetch(request)
        
        var outSounds : [Sound] = [Sound]()
        
        for soundCore in soundsCore {
            var newWaves : [SingleWave] = [SingleWave]()
            
            let request = SingleWaveCore.fetchRequest() as NSFetchRequest<SingleWaveCore>
            request.relationshipKeyPathsForPrefetching = ["mixeCore"]
            request.predicate = NSPredicate(format: "sound == %@", soundCore)
            
            let oldSingleWavesCore : [SingleWaveCore] = try! context.fetch(request)
            
            print("oldSingleWavesCore \(oldSingleWavesCore.count)")
            for oldSingleWaveCore in oldSingleWavesCore {
                let newSindgleWave = SingleWave(id: oldSingleWaveCore.id ?? UUID(), volume: oldSingleWaveCore.volume, number: Int(oldSingleWaveCore.number), color: ColorType(rawValue: oldSingleWaveCore.color ?? "White") ?? ColorType.White)
                newWaves.append(newSindgleWave)
            }
            
            if soundCore.soundDuration != nil {
                
            }
            let newSound = Sound(id: soundCore.id ?? UUID(), waves: newWaves.sorted(by: {$0.number < $1.number}), timeInBed: soundCore.timeInBed, started: soundCore.started ?? Date(), stoped: soundCore.stoped ?? Date(), fileName: soundCore.fileName ?? "", inDayCound: Int(soundCore.inDayCound), soundDuration: soundCore.soundDuration)
            outSounds.append(newSound)
            
        }
        
        return outSounds
    }
    
}
