//
//  SingleSoundView.swift
//  shonre
//
//  Created by Александр Шендрик on 07.10.2021.
//

import SwiftUI

struct SingleSoundView: View {
    @EnvironmentObject var DS : DataStorage
    @ObservedObject var player : SingleWaveSoundPlayer
    
    @State var isPlaying : Bool = false
    
    var body: some View {
        VStack{
            
            PlayerChartComponent(player: player).padding(.horizontal, 15)
            SoundScrollPlayComponent(player: player).padding(.horizontal, 15)
            
            HStack{
                Spacer()
                
                Button(action: {
                    player.addTime(-15)
                }){
                    Image(systemName: "gobackward.15").resizable().aspectRatio(contentMode: .fit).foregroundColor(.white).frame(width: 22, height: 22)
                }
                
                
                Button(action: {
                    player.isPlaying.toggle()
                }){
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill").resizable().aspectRatio(contentMode: .fit).foregroundColor(.white).frame(width: 34, height: 34).onReceive(player.$isPlaying, perform: {val in
                        isPlaying = val
                    })
                }
                
                Button(action: {
                    player.addTime(15)
                }){
                    Image(systemName: "goforward.15").resizable().aspectRatio(contentMode: .fit).foregroundColor(.white).frame(width: 22, height: 22)
                }
                Spacer()
                
            }
            
            Spacer()
            HStack{
                Spacer()
            }
        }.background(Color("Back").ignoresSafeArea())
    }
}

//struct SingleSoundView_Previews: PreviewProvider {
//    static var previews: some View {
//        SingleSoundView()
//    }
//}
