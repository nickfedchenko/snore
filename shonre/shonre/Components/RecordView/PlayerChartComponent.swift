//
//  PlayerChartComponent.swift
//  shonre
//
//  Created by Александр Шендрик on 07.10.2021.
//

import SwiftUI

struct PlayerChartComponent: View {
    @ObservedObject var player : SingleWaveSoundPlayer
    @State var proggres : Double = 0.0
    let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    
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
                Rectangle().foregroundColor(Color.white.opacity(0.5)).frame(width: 10, height: height).offset(x: CGFloat(proggres / 100.0) * UIScreen.main.bounds.width - 5)
            }.frame(width: proxy.size.width, height: height).background(Color.blue).clipped().onReceive(timer, perform: {_ in
                self.proggres = player.getProggres()
                print(self.proggres)
            })
        }.frame(height: height)
    }
}

//struct PlayerChartComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayerChartComponent()
//    }
//}
