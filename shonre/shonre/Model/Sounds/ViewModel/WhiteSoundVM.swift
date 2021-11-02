//
//  WhiteSoundViewModel.swift
//  whitesound
//
//  Created by Александр Шендрик on 31.08.2021.
//

import Foundation
import Combine


class WhiteSoundVM: ObservableObject {
    @Published var soundsShow : [[WhiteSound?]]
    @Published var selectedType : SoundType = SoundType.All
    @Published var allSounds : [WhiteSound]
    
    @Published var allSoundsView : [[[WhiteSound]]] = [[[WhiteSound]]]()
    
    var cancellables = Set<AnyCancellable>()
    
    init(sounds : [WhiteSound]) {
        self.soundsShow = [[WhiteSound?]]()
        self.allSounds = sounds
//        resetSounds(type: selectedType)
        
        $selectedType.sink(receiveValue: { type in
//            self.resetSounds(type: type)
        }).store(in: &cancellables)
        
    }
    
    func reset(){
        allSoundsView = [[[WhiteSound]]]()
        for type in SoundTypeList.data {
            let row = setView(sounds: self.allSounds, type: type.type)
            print(type.type.name())
            print(row.count)
            if !row.isEmpty{
                allSoundsView.append(row)
            }
        }
    }
    
    
    func setView(sounds : [WhiteSound], type : SoundType) -> [[WhiteSound]] {
        let soundsShuffled = type != .All ? sounds.filter({$0.type == type}).shuffled() : sounds.shuffled()
       
        var array = [[WhiteSound]]()
        let maxRow = soundsShuffled.count / 3 + soundsShuffled.count % 3
        
        for i in 0..<maxRow {
            var newLine = [WhiteSound]()
            for j in 0...3 {
                if i*3 + j < soundsShuffled.count {
                    newLine.append(soundsShuffled[i*3 + j])
                }
            }
            array.append(newLine)
        }
        
        return array
    }
    
}

//func resetSounds(type : SoundType){
//
//    var selectedSounds = allSounds
//    if type != .All {
//        selectedSounds = self.allSounds.filter({$0.type == type})
//    }
//
//    var rowsCount : Int = selectedSounds.count / 3
//    if selectedSounds.count % 3 > 0 {
//        rowsCount += 1
//    }
//
//    self.soundsShow = [[WhiteSound?]]()
//    for i in 0...rowsCount {
//        var newSoundsRow = [WhiteSound?]()
//        for j in 0...2 {
//            let index = 3 * i + j
//            if index < selectedSounds.count {
//                newSoundsRow.append(selectedSounds[index])
//            } else {
//                newSoundsRow.append(nil)
//            }
//        }
//        self.soundsShow.append(newSoundsRow)
//    }
//}
