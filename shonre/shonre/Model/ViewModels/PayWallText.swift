//
//  PayWallText.swift
//  shonre
//
//  Created by Александр Шендрик on 12.10.2021.
//

import Foundation

class PayWallText: Codable {
    var lang : String
    var text : String // T
    var title : String
    var ButtonText : String
    var price : String
    var crossView : Bool
    var purchaseId : String
    
    
     required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.lang = try container.decode(String.self, forKey: .lang)
        self.text = try container.decode(String.self, forKey: .text)
        self.title = try container.decode(String.self, forKey: .title)
        self.price = try container.decode(String.self, forKey: .price)
        self.ButtonText = try container.decode(String.self, forKey: .ButtonText)
        self.crossView = try container.decode(String.self, forKey: .crossView).lowercased() == "true"
        self.purchaseId = try container.decode(String.self, forKey: .purchaseId)
    }
    
    
    enum CodingKeys: String, CodingKey {
        case lang = "lang"
        case text = "tittle1"
        case title = "subtittle1"
        case price = "price1"
        case ButtonText = "ButtonText"
        case crossView = "crossView"
        case purchaseId = "purchaseId1"
    }
    
}
