//
//  SoundVolumeComponent.swift
//  whitesound
//
//  Created by Александр Шендрик on 02.09.2021.
//

import SwiftUI

struct SoundVolumeComponent: View {
    @ObservedObject var sound : WhiteSound
    @State var soundVolume : Float = 50.0
    
    var body: some View {
        if sound.isPlaying {
            HStack(alignment:.center){
                VStack{
                    SoundImage(sound).clipShape(Circle())
                }.frame(width: 47, height: 47).padding(.trailing, 10)
                VStack(alignment: .leading){
                    HStack{
                        Text(sound.name).foregroundColor(.white).font(.system(size: 14))
                        Spacer()
                    }
                }.frame(width: 100)
                ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)){
                    GeometryReader{ proxy in
                        Capsule().fill(Color.white).frame(width: proxy.size.width, height: 6)
                        Capsule().fill(Color("ButtonRed")).frame(width: proxy.size.width * CGFloat(soundVolume) / 100, height: 6)
                        Circle().frame(width: 21, height: 21).foregroundColor(Color.white).offset(x: proxy.size.width * CGFloat(soundVolume) / 100 - 10.5, y: -7).gesture(DragGesture().onChanged({ val in
                            let x = val.location.x
                            
                            self.sound.volume = Float(x / proxy.size.width)
                            if self.sound.volume < 0 {
                                self.sound.volume = 0.0
                            }
                            if self.sound.volume > 1 {
                                self.sound.volume = 1.0
                            }
                            self.soundVolume = self.sound.volume * 100.0
                        }))
                    }.padding(.top,6)
                    
                }.frame(height:16).onAppear(perform: {
                    self.soundVolume = self.sound.volume * 100.0
                })
                Button(action: {
                    sound.isPlaying = false
                }){
                    Image("cross").resizable().renderingMode(.template).foregroundColor(Color.white).frame(width : 8, height: 8).padding(.leading, 19)
                }
            }.padding(.horizontal)
        } else {
            EmptyView()
        }
    }
}

struct SoundVolumeComponent_Previews: PreviewProvider {
    static var previews: some View {
        SoundVolumeComponent(sound: WhiteSound.data[0])
    }
}
