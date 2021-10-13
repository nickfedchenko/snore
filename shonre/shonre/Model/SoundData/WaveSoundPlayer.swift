//
//  WaveSoundPlayer.swift
//  shonre
//
//  Created by Александр Шендрик on 07.10.2021.
//

import Foundation

class WaveSoundPlayer : ObservableObject{
    var singlePlayers : [SingleWaveSoundPlayer]
    
    
    init(sounds : [Sound]){
        self.singlePlayers = sounds.map({SingleWaveSoundPlayer(sound: $0)})
    }
    
    func getPlayer(for sound : Sound) -> SingleWaveSoundPlayer {
        return singlePlayers.first(where: {$0.sound.id == sound.id})!
    }
    
    func addSound(_ sound : Sound){
        self.singlePlayers.append(SingleWaveSoundPlayer(sound: sound))
    }
    
}
