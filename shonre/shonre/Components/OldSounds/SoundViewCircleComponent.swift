//
//  SoundViewCircleComponent.swift
//  whitesound
//
//  Created by Александр Шендрик on 02.09.2021.
//

import SwiftUI
import Amplitude
import StoreKit

struct SoundViewCircleComponent: View {
    @EnvironmentObject var DS : DataStorage
    @ObservedObject var sound : WhiteSound
    

    
    var body: some View {
        Button(action: {
            if (DS.soundStack.soundPlayer.playingSounds.count < 3 && !DS.apphudHelper.isPremium) || DS.apphudHelper.isPremium || DS.isTest {
                sound.isPlaying.toggle()
            } else {
                if !sound.isPlaying {
                    DS.viewControll.showPayWall = true
                    DS.viewControll.showSoundsView = false
                } else {
                    sound.isPlaying.toggle()
                }
            }
            if DS.soundStack.soundPlayer.playingSounds.count == 3 {
//                SKStoreReviewController.requestReview()
            }
                
        }){
            VStack{
                ZStack{
                    VStack{
                        SoundImage(sound)
                    }.frame(width: 86, height: 86).clipShape(Circle()).overlay(sound.isPlaying ? AnyView(Image("playing").offset(x: 30, y: 30)) : AnyView(Text("").hidden()))
                    if sound.isPlaying {
                        if DS.soundStack.soundPlayer.isPlaying {
                            LottieView(name: "playlot", loopMode: .loop).foregroundColor(.white).frame(width: 32, height: 32)
                        } else {
                            
                        }
                    }
                }
                Text(sound.name).font(.system(size: UIScreen.main.bounds.width > 320 ? 16 : 12)).foregroundColor(.white)
            }.frame(width: UIScreen.main.bounds.width / 3)
        }
    }
}

struct SoundViewCircleComponent_Previews: PreviewProvider {
    static var previews: some View {
        SoundViewCircleComponent(sound : WhiteSound.data[0])
    }
}
