//
//  PayWallText.swift
//  shonre
//
//  Created by Александр Шендрик on 12.10.2021.
//

import Foundation

class PayWallText: Codable {
    var lang : String
    var text : String
    var title : String
    var ButtonText : String
    var crossView : Bool
    var purchaseId : String
    
    
     required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.lang = try container.decode(String.self, forKey: .lang)
        self.text = try container.decode(String.self, forKey: .text)
        self.title = try container.decode(String.self, forKey: .title)
        self.ButtonText = try container.decode(String.self, forKey: .ButtonText)
        self.crossView = try container.decode(String.self, forKey: .crossView).lowercased() == "true"
        self.purchaseId = try container.decode(String.self, forKey: .purchaseId)
    }
    
    
    
//    init() {
//        var lang : String
//        var text : String
//        var title : String
//        var ButtonText : String
//        var crossView : String
//        var purchaseId : String
//    }
    
    enum CodingKeys: String, CodingKey {
        case lang
        case text
        case title
        case ButtonText
        case crossView
        case purchaseId
    }
    
}
