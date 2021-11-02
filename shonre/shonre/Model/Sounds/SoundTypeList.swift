//
//  SoundType.swift
//  whitesound
//
//  Created by Александр Шендрик on 02.09.2021.
//

import Foundation

struct SoundTypeList: Identifiable {
    var id = UUID ()
    var type : SoundType
    var possition : Int
    var text : String
    
    init(type: SoundType, possition: Int) {
        self.type = type
        self.possition = possition
        self.text = ""
        
        switch type {
        case .All:
            self.text = "All"
        case .Animals:
            self.text = "Animals"
        case .Child:
            self.text = "Child"
        case .City:
            self.text = "City"
        case .Instumental:
            self.text = "Instumental"
        case .Nature:
            self.text = "Nature"
        case .Technique:
            self.text = "Technique"
        case .Water:
            self.text = "Water"
        case .Noise:
            self.text = "Noise"
        }
    }
}

extension SoundTypeList {
    static var data = [SoundTypeList(type: .All, possition: 0), SoundTypeList(type: .Animals, possition: 1), SoundTypeList(type: .Child, possition: 2), SoundTypeList(type: .City, possition: 3), SoundTypeList(type: .Instumental, possition: 4), SoundTypeList(type: .Nature, possition: 5), SoundTypeList(type: .Technique, possition: 6), SoundTypeList(type: .Water, possition: 7), SoundTypeList(type: .Noise, possition: 7),]
}
