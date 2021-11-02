//
//  AddMixeImagesComponent.swift
//  whitesound
//
//  Created by Александр Шендрик on 11.09.2021.
//

import SwiftUI

struct AddMixeImagesComponent: View {
    @ObservedObject var soundPlayer : SoundPlayer
    
    
    var body: some View {
        ZStack(alignment:.trailing){
            if soundPlayer.playingSounds.count >= 3 {
                VStack{
                    SoundImage(soundPlayer.playingSounds[2].sound).clipShape(Circle())
                }.frame(width: 64, height: 64).offset(x: -32)
                VStack{
                    SoundImage(soundPlayer.playingSounds[1].sound).clipShape(Circle())
                }.frame(width: 64, height: 64).offset(x: 0)
                VStack{
                    SoundImage(soundPlayer.playingSounds[0].sound).clipShape(Circle())
                }.frame(width: 64, height: 64).offset(x: 32)
            }
            if soundPlayer.playingSounds.count == 2 {
                VStack{
                    SoundImage(soundPlayer.playingSounds[1].sound).clipShape(Circle())
                }.frame(width: 64, height: 64).offset(x: 0)
                VStack{
                    SoundImage(soundPlayer.playingSounds[0].sound).clipShape(Circle())
                }.frame(width: 64, height: 64).offset(x: 32)
            }
            if soundPlayer.playingSounds.count == 1 {
                VStack{
                    SoundImage(soundPlayer.playingSounds[0].sound).clipShape(Circle())
                }.frame(width: 64, height: 64).offset(x: 32)
            }
        }.frame(width: 36 + CGFloat(44 * (3 - 1)))
    }
}

//struct AddMixeImagesComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        AddMixeImagesComponent()
//    }
//}
