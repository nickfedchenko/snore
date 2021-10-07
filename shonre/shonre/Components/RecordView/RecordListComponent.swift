//
//  RecordListComponent.swift
//  shonre
//
//  Created by Александр Шендрик on 01.10.2021.
//

import SwiftUI

struct RecordListComponent: View {
    @EnvironmentObject var DS : DataStorage
    
    
    
    @ObservedObject var sound : Sound
    var player : SingleWaveSoundPlayer
    @State var isPlaying : Bool = false
    
    @Binding var activeSound : SingleWaveSoundPlayer?
    @Binding var isLinkActive : Bool
    
    init(player : SingleWaveSoundPlayer, activeSound : Binding<SingleWaveSoundPlayer?>, isLinkActive : Binding<Bool>){
        self.player = player
        self.sound = player.sound
        self._activeSound = activeSound
        self._isLinkActive = isLinkActive
        
    }
    
    var body: some View {
        VStack{
            HStack{
                Text("Recording 1").font(.system(size: 17, weight: .medium)).foregroundColor(.white)
                Spacer()
                Text(sound.getDateSting()).font(.system(size: 14, weight: .thin)).foregroundColor(.white)
            }
            
            HStack{
                Button(action: {
                    player.isPlaying.toggle()
                }){
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill").resizable().aspectRatio(contentMode: .fit).foregroundColor(.white).frame(width: 34, height: 34).onReceive(player.$isPlaying, perform: {val in
                        isPlaying = val
                    })
                }
                Button(action: {
                    self.activeSound = player
                    self.isLinkActive = true
                }){
                    SoundGraphRecordComponent(sound: sound)
                    Spacer()
                    Image("Arrow")
                }
            }.padding(.bottom, 25).padding(.top, 19)
            Divider()
        }.padding(.horizontal).padding(.top, 25)
    }
}

//struct RecordListComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordListComponent(sound: Sound.data[0])
//    }
//}
