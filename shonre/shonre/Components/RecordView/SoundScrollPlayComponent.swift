//
//  SoundScrollComponent.swift
//  shonre
//
//  Created by Александр Шендрик on 07.10.2021.
//

import SwiftUI

struct SoundScrollPlayComponent: View {
    @ObservedObject var player : SingleWaveSoundPlayer
    @State var proggres : Double = 0.0
    
    let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack{
            ZStack{
                GeometryReader{ proxy in
                    Capsule().fill(Color.white.opacity(0.3)).frame(width: proxy.size.width, height: 6)
                    Capsule().fill(Color.white).frame(width: proxy.size.width * CGFloat(proggres) / 100, height: 6)
                    Circle().frame(width: 12, height: 12).foregroundColor(Color.white).offset(x: proxy.size.width * CGFloat(proggres) / 100 - 6, y: -3).gesture(DragGesture().onChanged({ val in
                        let x = val.location.x
                        player.isPlaying = false
                        
                        self.proggres = Double(x / proxy.size.width) * 100
                        
                        if self.proggres < 0 {
                            self.proggres = 0.0
                        }
                        
                        if self.proggres > 100 {
                            self.proggres = 100.0
                        }
                        player.setTime(proggres: self.proggres)
                        self.proggres = self.player.getProggres()
                    }).onEnded({ val in
                        let x = val.location.x
                        player.isPlaying = true
                        
                        self.proggres = Double(x / proxy.size.width) * 100
                        
                        if self.proggres < 0 {
                            self.proggres = 0.0
                        }
                        
                        if self.proggres > 100 {
                            self.proggres = 100.0
                        }
                        
                        player.setTime(proggres: self.proggres)
                        self.proggres = self.player.getProggres()
                        player.isPlaying = true
                    })).onReceive(timer) {_ in
                        if player.isPlaying{
                            self.proggres = self.player.getProggres()
                        }
                    }
                }
            }.frame(height:16)
            HStack {
                Text(player.timeText).foregroundColor(Color.white).font(.system(size: 14, weight: .light))
                Spacer()
                Text(player.durationText).foregroundColor(Color.white).font(.system(size: 14, weight: .light))
            }
        }
    }
}

//struct SoundScrollComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        SoundScrollComponent()
//    }
//}
