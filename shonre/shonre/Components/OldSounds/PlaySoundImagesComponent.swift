//
//  PlaySoundImagesComponent.swift
//  whitesound
//
//  Created by Александр Шендрик on 03.09.2021.
//

import SwiftUI

struct PlaySoundImagesComponent: View {
    @ObservedObject var soundPlayer : SoundPlayer
    
    
    var body: some View {
        ZStack(alignment:.trailing){
            if soundPlayer.playingSounds.count >= 3 {
                VStack{
                    SoundImage(soundPlayer.playingSounds[2].sound).clipShape(Circle())
                }.frame(width: 40, height: 40).offset(x: -20)
                VStack{
                    SoundImage(soundPlayer.playingSounds[1].sound).clipShape(Circle())
                }.frame(width: 40, height: 40).offset(x: 0)
                VStack{
                    SoundImage(soundPlayer.playingSounds[0].sound).clipShape(Circle())
                }.frame(width: 40, height: 40).offset(x: 20)
            }
            if soundPlayer.playingSounds.count == 2 {
                VStack{
                    SoundImage(soundPlayer.playingSounds[1].sound).clipShape(Circle())
                }.frame(width: 40, height: 40).offset(x: 0)
                VStack{
                    SoundImage(soundPlayer.playingSounds[0].sound).clipShape(Circle())
                }.frame(width: 40, height: 40).offset(x: 20)
            }
            if soundPlayer.playingSounds.count == 1 {
                VStack{
                    SoundImage(soundPlayer.playingSounds[0].sound).clipShape(Circle())
                }.frame(width: 40, height: 40).offset(x: 20)
            }
        }.frame(width: 40 + CGFloat(24 * (3 - 1))).padding(.leading, 16).padding(.trailing, 13)
    }
}

struct PlaySoundImagesComponent_Previews: PreviewProvider {
    static var previews: some View {
        PlaySoundImagesComponent(soundPlayer: SoundPlayer())
    }
}
