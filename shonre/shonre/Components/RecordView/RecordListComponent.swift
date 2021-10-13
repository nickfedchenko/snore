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
    
    @Binding var toDeleteSound : Sound?
    @Binding var toDelete : Bool
    
    @State var xOffset : CGFloat = 0
    
    init(player : SingleWaveSoundPlayer, activeSound : Binding<SingleWaveSoundPlayer?>, isLinkActive : Binding<Bool>, toDeleteSound : Binding<Sound?>, toDelete : Binding<Bool>){
        self.player = player
        self.sound = player.sound
        self._activeSound = activeSound
        self._isLinkActive = isLinkActive
        self._toDeleteSound = toDeleteSound
        self._toDelete = toDelete
    }
    
    var body: some View {
        ZStack{
            HStack{
                Spacer()
                ZStack{
                    Rectangle().frame(width: 74).foregroundColor(.red)
                    Button(action: {
                        self.toDeleteSound = sound
                        
                        withAnimation{
                            self.toDelete = true
                            self.xOffset = 0
                        }
                    }){
                        VStack{
                            Image(systemName: "trash")
                            Text("Delete").font(.system(size: 12)).foregroundColor(.white)
                        }
                    }
                }
            }
            VStack{
                HStack{
                    Text("Record \(sound.inDayCound)").font(.system(size: 17, weight: .medium)).foregroundColor(.white)
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
                    
                    SoundGraphRecordComponent(sound: sound)
                    Button(action: {
                        self.activeSound = player
                        self.isLinkActive = true
                        self.xOffset = 0
                    }){
                        Spacer()
                        Image("Arrow")
                    }
                }.padding(.bottom, 25).padding(.top, 19)
                Divider()
            }.padding(.horizontal).padding(.top, 25).background(Color("Back")).offset(x: xOffset)
        }.fixedSize(horizontal: false, vertical: true).gesture(DragGesture().onChanged({ val in
            let delta = val.startLocation.x - val.location.x
            
            if delta < 0 {
                withAnimation{
                    self.xOffset = 0
                }
            }
            
            if delta > 0 {
                withAnimation{
                    self.xOffset = -74
                }
            }
            })
        )
    }
}

//struct RecordListComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordListComponent(sound: Sound.data[0])
//    }
//}
