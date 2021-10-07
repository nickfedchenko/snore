//
//  ResultsView.swift
//  shonre
//
//  Created by Александр Шендрик on 01.10.2021.
//

import SwiftUI

struct ResultsView: View {
    @EnvironmentObject var DS : DataStorage
    @State var sounds : [Sound] = [Sound]()
    
    @State var activeSound : SingleWaveSoundPlayer? = nil
    @State var isLinkActive : Bool = false
    
    var body: some View {
        NavigationView{
            ScrollView{
                LazyVStack{
                    HStack{
                        Text("Monday,02.09.2021").font(.system(size: 19, weight: .medium)).foregroundColor(.white)
                        Spacer()
                    }.padding(.horizontal)
                    
                    ForEach(sounds){ sound in
                        RecordListComponent(player: DS.soundAnalyzer.soundPlayer.getPlayer(for: sound), activeSound : $activeSound, isLinkActive : $isLinkActive)
                    }
                    
                    Spacer()
                    HStack{
                        Spacer()
                    }
                }
                
                if activeSound != nil {
                    NavigationLink(destination: SingleSoundView(player: activeSound!), isActive: $isLinkActive){
                        EmptyView()
                    }
                }
            }.navigationBarTitle("", displayMode: .automatic).navigationBarHidden(true).background(Color("Back").ignoresSafeArea())
        }.onAppear(perform: {
            self.sounds = DS.soundAnalyzer.sounds
        }).onReceive(DS.soundAnalyzer.$sounds, perform: {val in
            self.sounds = val
        })
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView()
    }
}
