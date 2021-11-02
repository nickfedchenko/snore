//
//  Mixe.swift
//  whitesound
//
//  Created by Александр Шендрик on 09.09.2021.
//

import Foundation
import SwiftUI

class Mixe: ObservableObject, Identifiable, Codable {
    @Published var id : UUID
    @Published var sounds : [MixeSound]
    @Published var name : String
    @Published var type : MixeType
    @Published var imageLink : String?
    @Published var imageFileName : String?
    @Published var uiImage : UIImage?
    @Published var likes : Int
    @Published var liked : Bool = false
    
    init(id : UUID, sounds : [MixeSound], name : String, type : MixeType, imageLink : String?, imageFileName : String?) {
        self.id = id
        self.sounds = sounds
        self.name = name
        self.type = type
        self.likes = 0
        self.imageLink = imageLink
        self.imageFileName = imageFileName
        if self.imageFileName != nil{
            self.uiImage = self.getImage()
        }
    }
    
    func addSound(_ sound : WhiteSound, volume : Float) {
        let oldsound = sounds.first(where: {$0.soundID == sound.FBid})
        if oldsound == nil {
            let lastPos = self.sounds.last != nil ? self.sounds.last!.possition + 1 : 0
            self.sounds.append(MixeSound(soundID: sound.FBid, volume: volume, possition: lastPos))
        }
    }
    
    func updeteSound(_ sound : WhiteSound, volume : Float) {
        let oldsound = sounds.first(where: {$0.soundID == sound.FBid})
        
        if oldsound != nil {
            oldsound?.volume = volume
        } else {
            addSound(sound, volume: volume)
        }
    }
    
    func removeSound(_ sound : WhiteSound) {
        let oldsoundIndex = sounds.firstIndex(where: {$0.soundID == sound.FBid})
        
        if oldsoundIndex != nil {
            sounds.remove(at: oldsoundIndex!)
        }
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if container.contains(.imageLink) {
            self.imageLink = try container.decode(String.self, forKey: .imageLink)
        }
        
        let langStr = Locale.current.languageCode
        
        self.name = ""
        if container.contains(.nameru) && container.contains(.nameen) {
            let nameru = try container.decode(String.self, forKey: .nameru).capitalizingFirstLetter()
            let nameen = try container.decode(String.self, forKey: .nameen).capitalizingFirstLetter()
            
            if langStr == "en" {
                self.name = nameen
            }
            if langStr == "ru" {
                self.name = nameru
            }
        }
        
        if container.contains(.name) {
            self.name = try container.decode(String.self, forKey: .name).capitalizingFirstLetter()
        }
        
        self.likes = 0
        if container.contains(.likes) {
            do {
                self.likes = try container.decode(Int.self, forKey: .likes)
            } catch {
                self.likes = Int(try container.decode(String.self, forKey: .likes)) ?? 1
            }
        }
        
        
        self.id = UUID()
        if container.contains(.id) {
            do {
                self.id = try container.decode(UUID.self, forKey: .id)
            } catch {
                self.id = UUID(uuidString: try container.decode(String.self, forKey: .id)) ?? UUID()
            }
        }
        
        if container.contains(.type) {
            let rawType = try container.decode(String.self, forKey: .type)
            self.type = MixeType(rawValue: rawType) ?? .All
        } else {
            self.type = .Home
        }
        self.sounds = [MixeSound]()
        
        for i in 1...5{
            if container.contains(Mixe.CodingKeys(rawValue: "sound\(i)_id") ?? .sound1_id) {
                let soundID = try container.decode(String.self, forKey: Mixe.CodingKeys(rawValue: "sound\(i)_id") ?? .sound1_id)
                if soundID != " " {
                    let newMixeSound = MixeSound(soundID: soundID, volume: 1.0, possition: 1)
                    self.sounds.append(newMixeSound)
                }
            }
        }
        
//        if container.contains(.likes) {
//            self.likes = Int(try container.decode(String.self, forKey: .likes)) ?? nil
//        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case nameru = "name_ru"
        case nameen = "name_en"
        case imageLink = "imageLink"
        case sound1_id = "sound1_id"
        case sound2_id = "sound2_id"
        case sound3_id = "sound3_id"
        case sound4_id = "sound4_id"
        case sound5_id = "sound5_id"
        case type = "category"
        case likes = "likes"
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        
        if sounds.count > 0 {
            try container.encode(sounds[0].soundID, forKey: .sound1_id)
        }
        if sounds.count > 1 {
            try container.encode(sounds[1].soundID, forKey: .sound2_id)
        }
        if sounds.count > 2 {
            try container.encode(sounds[2].soundID, forKey: .sound3_id)
        }
        if sounds.count > 3 {
            try container.encode(sounds[3].soundID, forKey: .sound4_id)
        }
        if sounds.count > 4 {
            try container.encode(sounds[4].soundID, forKey: .sound5_id)
        }
        
        try container.encode(type, forKey: .type)
        try container.encode(likes, forKey: .likes)
        try container.encode(id, forKey: .id)
    }
    
    
    func getImage() -> UIImage? {
        if self.imageFileName != nil{
            let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
            let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
            let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
            
            if let dirPath = paths.first {
                let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(self.imageFileName!)
                let image    = UIImage(contentsOfFile: imageURL.path)
                return image
               // Do whatever you want with the image
            }
        }
        return nil
    }
    
}


class MixeSound : Codable {
    var soundID : String
    var volume : Float
    var possition : Int
    
    init(soundID : String, volume : Float, possition : Int) {
        self.soundID = soundID
        self.volume = volume
        self.possition = possition
    }
}


enum MixeType: String, Codable{
    typealias RawValue = String
    case All = "All"
    case Sleep = "Sleep"
    case Work = "Work"
    case Meditation = "Meditation"
    case Home = "Home"
    
    func name() -> String {
        return self.rawValue
    }
}



struct MixeTypeList: Identifiable, Hashable {
    var id = UUID()
    var type: MixeType
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id.uuidString)
    }
}

extension MixeTypeList {
    static var data : [MixeTypeList] = [.init(type: .Meditation), .init(type: .Sleep), .init(type: .Work)]
}
