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
    @State var timeText : String = "00:00"
    @State var wasPlaying : Bool = false
    @State var dragging : Bool = false
    
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack{
            ZStack{
                GeometryReader{ proxy in
                    Capsule().fill(Color.white.opacity(0.3)).frame(width: proxy.size.width, height: 6)
                    Capsule().fill(Color.white).frame(width: proxy.size.width * CGFloat(proggres) / 100, height: 6)
                    Circle().frame(width: 12, height: 12).foregroundColor(Color("ButtonRed")).offset(x: proxy.size.width * CGFloat(proggres) / 100 - 6, y: -3).gesture(DragGesture().onChanged({ val in
                        let x = val.location.x
                        self.dragging = true
                        self.wasPlaying = player.isPlaying
                        player.isPlaying = false
                        
                        
                        self.proggres = Double(x / proxy.size.width) * 100
                        if self.proggres < 0 {
                            self.proggres = 0.0
                        }
                        
                        if self.proggres > 100 {
                            self.proggres = 100.0
                        }
                        player.setTime(proggres: self.proggres)
                        self.timeText = self.player.getCurrentTime()
                    }).onEnded({ val in
                        let x = val.location.x
                        self.proggres = Double(x / proxy.size.width) * 100
                        
                        if self.proggres < 0 {
                            self.proggres = 0.0
                        }
                        
                        if self.proggres > 100 {
                            self.proggres = 100.0
                        }
                        self.dragging = false
                        player.setTime(proggres: self.proggres)
                        player.isPlaying = self.wasPlaying
                        self.timeText = self.player.getCurrentTime()
                    })).onReceive(timer) {_ in
                        if !self.dragging {
                            self.proggres = self.player.getProggres()
                            self.timeText = self.player.getCurrentTime()
                        }
                    }
                }
            }.frame(height:16)
            HStack {
                Text(timeText).foregroundColor(Color.white).font(.system(size: 14, weight: .light))
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
