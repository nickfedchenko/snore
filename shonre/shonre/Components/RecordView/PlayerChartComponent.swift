//
//  PlayerChartComponent.swift
//  shonre
//
//  Created by Александр Шендрик on 07.10.2021.
//

import SwiftUI

struct PlayerChartComponent: View {
    @ObservedObject var player : SingleWaveSoundPlayer
    let isActive : Bool
    
    @State var proggres : Double = 0.0
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    let countWaves : Int = 50
    
    let height : CGFloat = 102
    
    var body: some View {
        GeometryReader{ proxy in
            ZStack(alignment: .bottomLeading){
                HStack(alignment: .bottom, spacing: 1){
                    ForEach(player.sound.getGraphWaves(count: countWaves)){ wave in
                        VStack(alignment: .leading){
                            Spacer()
                            Capsule().frame(height: height * CGFloat(wave.volume)).foregroundColor(wave.color.getColor())
                        }
                    }
                }.frame(width: proxy.size.width, height: height)
                if isActive {
                    Rectangle().foregroundColor(Color.white.opacity(0.5)).frame(width: 10, height: height).offset(x: CGFloat(proggres / 100.0) * proxy.size.width - 5)
                }
            }.frame(width: proxy.size.width, height: height).clipped().onReceive(timer, perform: {_ in
                if isActive {
                    self.proggres = player.getProggres()
                }
            })
        }.frame(height: height)
    }
}

//struct PlayerChartComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayerChartComponent()
//    }
//}
