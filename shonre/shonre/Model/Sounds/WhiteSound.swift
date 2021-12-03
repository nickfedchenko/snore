//
//  WhiteSound.swift
//  whitesound
//
//  Created by Александр Шендрик on 31.08.2021.
//

import Foundation
import SwiftUI

class WhiteSound : Identifiable, ObservableObject, Codable {
    var id : UUID = UUID()
    var FBid : String
    var name : String
    var url : String
    var type : SoundType
    var imageLink : String
    var imgName : String
    
    var nameru : String = ""
    var nameen : String = ""
    
    // Изменяемы в данные, сохраняются в CoreData
    @Published var fileName : String?
    @Published var imgFileName : String?
    
    // Изменяемы в данные, НЕ сохраняются в CoreData
    @Published var isPlaying : Bool = false
    @Published var volume : Float = 1.0
    
    @Published var uiImage : UIImage?
    
    init(FBid : String, name : String, url : String, fileName : String?, type : SoundType, imgName : String, imgFileName : String?, imageLink : String) {
        self.FBid = FBid
        self.name = name
        self.url = url
        self.fileName = fileName
        self.type = type
        self.imgName = imgName
        self.imgFileName = imgFileName
        self.imageLink = imageLink
        
        if imgFileName != nil {
            self.uiImage = self.getImage()
        }
    }
    
    // init для теста
    init(name : String, type : SoundType, imgName : String, fileName : String) {
        self.FBid = ""
        self.name = name
        self.url = ""
        self.fileName = fileName
        self.type = type
        self.imgName = imgName
        self.imageLink = ""
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.nameru = try container.decode(String.self, forKey: .nameru).capitalizingFirstLetter()
        self.nameen = try container.decode(String.self, forKey: .nameen).capitalizingFirstLetter()
        self.type = try container.decode(SoundType.self, forKey: .type)
        self.url = try container.decode(String.self, forKey: .url)
        self.imageLink = try container.decode(String.self, forKey: .imageLink)
        self.FBid = try container.decode(String.self, forKey: .FBid)
        
        self.name = ""
        self.imgName = "noimage"
        
        let langStr = Locale.current.languageCode
        self.name = self.nameen
        
        if langStr == "ru" {
            self.name = self.nameru
        }
           
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
    }
    
    enum CodingKeys: String, CodingKey {
        case FBid = "id"
        case nameru = "name_ru"
        case nameen = "name_en"
        case type = "category"
        case url = "audioLink"
        case imageLink = "imageLink"
    }
    
    func getImage() -> UIImage? {
        if self.imgFileName != nil{
            let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
            let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
            let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
            
            if let dirPath = paths.first {
                let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(self.imgFileName!)
                let image    = UIImage(contentsOfFile: imageURL.path)
                return image
               // Do whatever you want with the image
            }
        }
        return nil
    }
}


enum SoundType : String, Codable{
    typealias RawValue = String
    case All = "All"
    case Animals = "animals"
    case Child = "child"
    case City = "city"
    case Instumental = "instumental"
    case Nature = "nature"
    case Technique = "technique"
    case Water = "water"
    case Noise = "noise"
    
    func name() -> String {
        let langStr = Locale.current.languageCode
        
        if langStr == "ru" {
            switch self {
            case .All:
                return "Все"
            case .Animals:
                return "Животные"
            case .Child:
                return "Ребёнок"
            case .City:
                return "Город"
            case .Instumental:
                return "Инструменты"
            case .Nature:
                return "Природа"
            case .Technique:
                return "Техника"
            case .Water:
                return "Вода"
            case .Noise:
                return "Шум"
            }
            
        }
        
        switch self {
        case .All:
            return "All"
        case .Animals:
            return "Animals"
        case .Child:
            return "Child"
        case .City:
            return "City"
        case .Instumental:
            return "Instumental"
        case .Nature:
            return "Nature"
        case .Technique:
            return "Technique"
        case .Water:
            return "Water"
        case .Noise:
            return "Noise"
        }
        
    }
}


extension WhiteSound {
    static var data = [WhiteSound(name: "", type: .All, imgName: "noimage", fileName: "fogs"), WhiteSound(name: "Природа", type: .Nature, imgName: "soundnature", fileName: "waves"), WhiteSound(name: "Дождь", type: .Water, imgName: "soundrain", fileName: "rain")]
}


extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
