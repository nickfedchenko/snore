//
//  SoundsView.swift
//  whitesound
//
//  Created by Александр Шендрик on 02.09.2021.
//

import SwiftUI

struct SoundsView: View {
    @EnvironmentObject var DS : DataStorage
    @EnvironmentObject var viewControll : ViewControll
    
    @Binding var isPresented : Bool
    @State var selected : SoundType = SoundType.All
    
    
    @State var selectedInt : Int = 0
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)){
            VStack{
                HStack{
                    Text("Sounds").font(.system(size: 30)).foregroundColor(Color.white)
                    Spacer()
                }.padding(.horizontal, 15).padding(.top, 30)
                TextScrollComponent(selectedInt: $selectedInt).padding(.bottom, 7)
                
                TabView(selection: $selectedInt) {
                    ForEach(0..<DS.soundStack.soundVM.allSoundsView.count, id : \.self){ i in
                        if !DS.soundStack.soundVM.allSoundsView[i].isEmpty {
                            let soundsShow = DS.soundStack.soundVM.allSoundsView[i]
                            OneSoundsView(soundsShow: soundsShow).tag(i)
                        }
                    }
                }.tabViewStyle(.page)
                
            }.frame(height: UIScreen.main.bounds.height - 35)
            
            VStack{
                Spacer()
                if DS.viewControll.showMixeBoard {
                    SoundPlayerBlackComponent(showMixer: $viewControll.possitionController, isToClose: true, isPresented: $isPresented).padding(.bottom, 50)
                }
            }

        }.edgesIgnoringSafeArea([.bottom]).background(Color("Back").ignoresSafeArea())
    }
}


struct SoundsView_Previews: PreviewProvider {
    static var previews: some View {
        SoundsView(isPresented: .constant(true))
    }
}

struct OneSoundsView: View {
    var soundsShow : [[WhiteSound]]
    
    var body : some View {
        ScrollView{
            LazyVStack{
                ForEach(0..<soundsShow.count, id: \.self){ rowNum in
                    HStack(alignment: .top){
                        ForEach(0...2, id: \.self){ soundNum in
                            if soundNum < soundsShow[rowNum].count {
                                SoundViewCircleComponent(sound: soundsShow[rowNum][soundNum])
                            } else {
                                Spacer().frame(width: UIScreen.main.bounds.width / 3)
                            }
                        }
                    }.padding(.horizontal).padding(.top, 38)
                }
            }
            Spacer().frame(height: 100)
        }.buttonStyle(PlainButtonStyle())
    }
}


//ScrollView{
//    LazyVStack{
//        ForEach(0..<DS.soundStack.soundVM.soundsShow.count, id: \.self){ rowNum in
//            HStack(alignment: .top){
//                ForEach(0...2, id: \.self){ soundNum in
//                    if DS.soundStack.soundVM.soundsShow[rowNum][soundNum] != nil {
//                        SoundViewCircleComponent(sound: DS.soundStack.soundVM.soundsShow[rowNum][soundNum]!)
//                        if soundNum != DS.soundStack.soundVM.soundsShow[rowNum].count - 1 {
//                            Spacer()
//                        }
//                    } else {
//                        Spacer()
//                    }
//                }
//            }.padding(.horizontal).padding(.top, 38)
//        }
//    }
//}.buttonStyle(PlainButtonStyle())

//ScrollView{
//    LazyVStack{
//        ForEach(0..<soundsShow.count, id: \.self){ rowNum in
//            HStack(alignment: .top){
//                ForEach(0...2, id: \.self){ soundNum in
//                    if soundsShow[rowNum][soundNum] != nil {
//                        SoundViewCircleComponent(sound: soundsShow[rowNum][soundNum])
//                        if soundNum != soundsShow[rowNum].count - 1 {
//                            Spacer()
//                        }
//                    } else {
//                        Spacer()
//                    }
//                }
//            }.padding(.horizontal).padding(.top, 38)
//        }
//    }
//}.buttonStyle(PlainButtonStyle()).tag(i)
