//
//  HomeSoundPreviewVM.swift
//  whitesound
//
//  Created by Александр Шендрик on 13.09.2021.
//

import Foundation

class HomeSoundPreviewVM: ObservableObject {
    @Published var soundsView : [[WhiteSound]] = [[WhiteSound]]()


    @Published var allSoundsView : [[[WhiteSound]]] = [[[WhiteSound]]]()
    
    init(sounds : [WhiteSound]) {
        reset(sounds: sounds)
    }

    func reset(sounds : [WhiteSound]){
        allSoundsView = [[[WhiteSound]]]()
        for type in SoundTypeList.data {
            let row = setView(sounds: sounds, type: type.type)
            print(type.type.name())
            print(row.count)
            if !row.isEmpty{
                allSoundsView.append(row)
            } else {
                allSoundsView.append([[WhiteSound]]())
            }
        }
    }
    
    
    func setView(sounds : [WhiteSound], type : SoundType) -> [[WhiteSound]] {
        let soundsShuffled = type != .All ? sounds.filter({$0.type == type}).shuffled() : sounds.shuffled()
       
        var array = [[WhiteSound]]()
        if soundsShuffled.count >= 6{
            for i in 0...2 {
                var newLine = [WhiteSound]()
                for j in 0...1 {
                    newLine.append(soundsShuffled[i*2 + j])
                }
                array.append(newLine)
            }
        }
        return array
    }
    
}


//let soundsShuffled = sounds.shuffled()
//self.soundsView = [[WhiteSound]]()
//if sounds.count >= 6{
//    for i in 0...2 {
//        var newLine = [WhiteSound]()
//        for j in 0...1 {
//            newLine.append(soundsShuffled[i*2 + j])
//        }
//        self.soundsView.append(newLine)
//    }
//}
