//
//  MixerView.swift
//  whitesound
//
//  Created by Александр Шендрик on 02.09.2021.
//

import SwiftUI

struct MixerView: View {
    @EnvironmentObject var DS : DataStorage
    @EnvironmentObject var viewControll : ViewControll
    @Binding var possitionController : CardPosition
    @State var textLabel : LocalizedStringKey = "No sounds"
    @State var isPlaying : Bool = false
    
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    DS.soundStack.soundPlayer.isPlaying.toggle()
                }){
                    Image("turnon")
                    Text(isPlaying ? "Turn off" : "Turn on").font(.system(size: 14)).foregroundColor(Color.white)
                }
                Spacer()
                Button(action: {
                    possitionController = .bottom
                }){
                    Image("arrowdown")
                }
            }.padding(.horizontal).padding(.top)
            
            Text(textLabel).font(.system(size: 22)).foregroundColor(Color.white).onAppear(perform: {
                textLabel = "\(DS.soundStack.soundPlayer.textLabel) Sounds"
                isPlaying = DS.soundStack.soundPlayer.isPlaying
            }).onReceive(DS.soundStack.soundPlayer.$textLabel, perform: {text in
                textLabel = "\(text) Sounds"
            }).onReceive(DS.soundStack.soundPlayer.$isPlaying, perform: {val in
                withAnimation{
                        isPlaying = val
                }
            })
            

            
//            if viewControll.showAddSoundButton {
//                Button(action: {
//                    viewControll.showSoundsView = true
//                }){
//                    HStack{
//                        Image(systemName: "plus")
//                        Text("Add sound")
//                    }.padding(10).background(RoundedRectangle(cornerRadius: 28).frame(height: 34).foregroundColor(Color("lightgray")))
//                }
//            }
            
            ScrollView{
                
                ForEach(DS.soundStack.soundPlayer.playingSounds, id: \.sound.id) {playingSound in
                    SoundVolumeComponent(sound: playingSound.sound)
                }
                
                HStack(alignment: .center){
                    Button(action: {
                        DS.viewControll.showChooseTime = .upmiddle
                    }){
                        VStack{
                            Image("clock")
                            Text(DS.soundStack.soundPlayer.stopPlay.textLabel).font(.system(size: 12)).foregroundColor(Color.white)
                        }.frame(width: 65)
                    }
                    
                    Button(action: {
                        DS.soundStack.soundPlayer.isPlaying.toggle()
                    }){
                        Image(systemName: isPlaying ? "pause.circle" : "play.circle").resizable().aspectRatio(contentMode: .fit).frame(width: 46).foregroundColor(.white)
                    }.padding(.horizontal, 45)
                    
                    Button(action: {
                        DS.soundStack.saveMixe(toPublic: false)
//                        DS.viewControll.showSaveMixe = true
                    }){
                        VStack{
                            Image("heart")
                            Text("Save").font(.system(size: 12)).foregroundColor(Color.white)
                        }.frame(width: 65)
                    }
                }.padding(.top, 29)
                    
            }
        }.background(Color("MixerColor"))
    }
}

struct MixerView_Previews: PreviewProvider {
    static var previews: some View {
        MixerView(possitionController: .constant(.bottom))
    }
}
