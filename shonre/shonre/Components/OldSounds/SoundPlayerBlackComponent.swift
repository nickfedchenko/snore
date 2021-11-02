//
//  SoundPlayerBlackComponent.swift
//  whitesound
//
//  Created by Александр Шендрик on 02.09.2021.
//

import SwiftUI

struct SoundPlayerBlackComponent: View {
    @EnvironmentObject var DS : DataStorage
    @Binding var showMixer : CardPosition
    var isToClose : Bool
    @Binding var isPresented : Bool
    
    @State var soundCount : Int = 3
    @State var isPlaying : Bool = true
    @State var textLabel : String = "0"
    
    init(showMixer : Binding<CardPosition>, isToClose : Bool = false, isPresented : Binding<Bool> = .constant(true)){
        self._showMixer = showMixer
        self.isToClose = isToClose
        self._isPresented = isPresented
    }
    
    var body: some View {
        ZStack{
            // Раздел с иконками
            HStack{
                Button(action: {
                    showMixer = CardPosition.top
                    DS.viewControll.showAddSoundButton = !isToClose
                }){
                    ZStack{
                        Circle().frame(width: 32, height: 32).foregroundColor(Color("ButtonRed")).offset(x: 3, y: 3)
                        Circle().frame(width: 32, height: 32).foregroundColor(Color.white)
                        Text(textLabel).foregroundColor(.black).font(.system(size: 16)).onReceive(DS.soundStack.soundPlayer.$textLabel, perform: {val in
                            self.textLabel = val
                        })
                    }
                    Text("Mix").font(.system(size: 14)).foregroundColor(.white)
                    
                    Spacer()
                }
                
                Button(action: {
                    DS.viewControll.showChooseTime = .upmiddle
                }){
                    Image("clock")
                }
                
                Button(action: {
                    DS.soundStack.soundPlayer.isPlaying.toggle()
                }){
                    Image(systemName: self.isPlaying ? "stop.circle.fill" : "play.circle.fill").renderingMode(.template).resizable().frame(width: 30, height: 30).foregroundColor(.white).padding(.leading, 10)
                }
//                Button(action: {
//                    showMixer = CardPosition.top
//                    DS.viewControll.showAddSoundButton = !isToClose
//                }){
//                    Image("whotearrowtop")
//                }
            }.padding(.horizontal)
        }.frame(height: 64).padding(.horizontal).background(Color("Plate")).onReceive(DS.soundStack.soundPlayer.$isPlaying, perform: {val in
            self.isPlaying = val
        })
    }
}

struct SoundPlayerBlackComponent_Previews: PreviewProvider {
    static var previews: some View {
        SoundPlayerBlackComponent(showMixer: .constant(CardPosition.bottom))
    }
}
