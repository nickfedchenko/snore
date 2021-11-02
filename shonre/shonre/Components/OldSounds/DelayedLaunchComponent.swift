//
//  DelayedLaunchComponent.swift
//  whitesound
//
//  Created by Александр Шендрик on 02.09.2021.
//

import SwiftUI

struct DelayedLaunchComponent: View {
    @ObservedObject var playAtTimeVM : PlayAtTimeVM
    @State var showContent : Bool = false
//    @State var toggle : Bool = false
//    @State var minutes : Int = 2
//    @State var secons : Int = 2
    
    
    
    var body: some View {
        VStack{
            HStack{
                Text("Delayed Launch").font(.system(size: 18))
                Spacer()
                Toggle("", isOn: $playAtTimeVM.isOn).toggleStyle(SwitchToggleStyle(tint: Color("AccentColor"))).fixedSize()
            }
            if showContent {
                HStack{
                    Text("Playback will start at").foregroundColor(Color("AccentColor"))
                    Spacer()

                    HStack{
                        Picker(selection: $playAtTimeVM.hour, label: Text("")) {
                            ForEach(0...23, id: \.self){ i in
                                Text(i > 9 ? String(i) : "0" + String(i)).tag(i).font(.system(size: 18))
                            }
                        }.background(Color("lightgray")).frame(width: 32, height: 32).clipped()
                        Picker(selection: $playAtTimeVM.minutes, label: Text("")) {
                            ForEach(0...60, id: \.self){ i in
                                Text(i > 9 ? String(i) : "0" + String(i)).tag(i).font(.system(size: 18))
                            }
                        }.frame(width: 32, height: 32).clipped()
                    }.padding(2).clipShape(RoundedRectangle(cornerRadius: 6)).overlay(RoundedRectangle(cornerRadius: 6).stroke(Color("AccentColor"), lineWidth: 1))
                }
            }
        }.padding(.horizontal,13).padding(.vertical,17).background(Color("lightgray")).clipShape(RoundedRectangle(cornerRadius: 8)).padding(.horizontal).onAppear{
            showContent = playAtTimeVM.isOn
        }.onReceive(playAtTimeVM.$isOn, perform: { val in
            withAnimation{
                self.showContent = val
            }
        })
    }
}

struct DelayedLaunchComponent_Previews: PreviewProvider {
    static var previews: some View {
        DelayedLaunchComponent(playAtTimeVM: PlayAtTimeVM())
    }
}
