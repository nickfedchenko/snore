//
//  PayWallText2.swift
//  shonre
//
//  Created by Александр Шендрик on 24.11.2021.
//

import Foundation

class PayWallText2: Codable {
    var lang : String
    var text : String 
    var title : String
    var ButtonText : String
    var crossView : Bool
    var purchaseId1 : String
    var purchaseId2 : String
    var purchaseId3 : String
    var time1 : String
    var time2 : String
    var time3 : String
    var show1 : Bool
    var show2 : Bool
    var show3 : Bool
    
    
     required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.lang = try container.decode(String.self, forKey: .lang)
        self.text = try container.decode(String.self, forKey: .text)
        self.title = try container.decode(String.self, forKey: .title)
        self.ButtonText = try container.decode(String.self, forKey: .ButtonText)
        self.crossView = try container.decode(String.self, forKey: .crossView).lowercased() == "true"
        self.purchaseId1 = try container.decode(String.self, forKey: .purchaseId1)
        self.purchaseId2 = try container.decode(String.self, forKey: .purchaseId2)
        self.purchaseId3 = try container.decode(String.self, forKey: .purchaseId3)
        self.time1 = try container.decode(String.self, forKey: .time1)
        self.time2 = try container.decode(String.self, forKey: .time2)
        self.time3 = try container.decode(String.self, forKey: .time3)
        self.show1 = try container.decode(String.self, forKey: .show1).lowercased() == "true"
        self.show2 = try container.decode(String.self, forKey: .show2).lowercased() == "true"
        self.show3 = try container.decode(String.self, forKey: .show3).lowercased() == "true"
    }
    
    
    enum CodingKeys: String, CodingKey {
        case lang = "lang"
        case text = "tittle1"
        case title = "subtittle1"
        case ButtonText = "ButtonText"
        case crossView = "crossView"
        case purchaseId1 = "purchaseId1"
        case purchaseId2 = "purchaseId2"
        case purchaseId3 = "purchaseId3"
        case time1 = "time1"
        case time2 = "time2"
        case time3 = "time3"
        case show1 = "show1"
        case show2 = "show2"
        case show3 = "show3"
    }
    
}
