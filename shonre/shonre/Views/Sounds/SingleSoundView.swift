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
    @Binding var isPresented : Bool
    @State var isPlaying : Bool = false
    
    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    Button(action: {
                        isPresented = false
                    }, label: {
                        Image(systemName: "chevron.left").foregroundColor(Color("ButtonRed"))
                        Text("Results").foregroundColor(Color("ButtonRed"))
                    })
                    Spacer()
                }.padding(.horizontal, 15).padding(.vertical)
                HStack{
                    Text("Recording \(player.sound.inDayCound)").foregroundColor(Color.white).font(.system(size: 17, weight: .medium))
                    Spacer()
                    Text(player.sound.getBeggingText()).foregroundColor(Color.white.opacity(0.9)).font(.system(size: 14))
                }.padding(.horizontal, 15)
                
                HStack{
                    Spacer()
                    
                    Circle().frame(width: 8, height: 8).foregroundColor(ColorType.White.getColor())
                    Text("Low").foregroundColor(Color.white).font(.system(size: 14))
                    
                    Circle().frame(width: 8, height: 8).foregroundColor(ColorType.Yellow.getColor()).padding(.leading, 30)
                    Text("Hight").foregroundColor(Color.white).font(.system(size: 14))
                    
                    Circle().frame(width: 8, height: 8).foregroundColor(ColorType.Red.getColor()).padding(.leading, 30)
                    Text("Loud").foregroundColor(Color.white).font(.system(size: 14))
                }.padding(.horizontal, 15)
                
                PlayerChartComponent(player: player, isActive: false).padding(.horizontal, 15)
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
                
                ZStack(alignment: .top){
                    VStack{
                        Spacer().frame(height: 25)
                        
                        HStack{
                            Image("recclock").padding(.leading, 18)
                            VStack(alignment: .leading){
                                Text("Started/Stoped").font(.system(size: 16)).foregroundColor(Color("RecGray"))
                                Text(player.sound.getStartedStopedText()).font(.system(size: 16)).foregroundColor(Color.white)
                            }.padding(.leading, 20)
                            Spacer()
                        }.padding(.vertical, 13).background(Color("Plate")).clipShape(RoundedRectangle(cornerRadius: 9)).padding(.horizontal, 15).padding(.bottom, 13)
                        
                        HStack{
                            Image("recbed").padding(.leading, 18)
                            VStack(alignment: .leading){
                                Text("Time in Bed").font(.system(size: 16)).foregroundColor(Color("RecGray"))
                                Text(player.sound.getTimeInBed()).font(.system(size: 16)).foregroundColor(Color.white)
                            }.padding(.leading, 20)
                            Spacer()
                        }.padding(.vertical, 13).background(Color("Plate")).clipShape(RoundedRectangle(cornerRadius: 9)).padding(.horizontal, 15).padding(.bottom, 13)
                        
                        HStack{
                            Image("reccloc2").padding(.leading, 18)
                            VStack(alignment: .leading){
                                Text("Time snoring").font(.system(size: 16)).foregroundColor(Color("RecGray"))
                                Text(player.sound.getTimeSnoring()).font(.system(size: 16)).foregroundColor(Color.white)
                            }.padding(.leading, 20)
                            Spacer()
                        }.padding(.vertical, 13).background(Color("Plate")).clipShape(RoundedRectangle(cornerRadius: 9)).padding(.horizontal, 15).padding(.bottom, 13)
                    }
                    
                    HStack(){
                        Spacer()
                        PieChartView(values: player.sound.chartParts(), colors: [ColorType.White.getColor(), ColorType.Yellow.getColor(), ColorType.Red.getColor()], colorsText: [ColorType.White.getTextColor(), ColorType.Yellow.getTextColor(), ColorType.Red.getTextColor()], backgroundColor: Color.clear).frame(width: UIScreen.main.bounds.width > 320 ? 112 : 80, height: UIScreen.main.bounds.width > 320 ? 112 : 80)
                        
                    }.padding(.trailing, 15)
                }
                
                Spacer()
                HStack{
                    Spacer()
                }
        }
        }.background(Color("Back").ignoresSafeArea()).navigationBarTitle("", displayMode: .inline).navigationBarHidden(true)
    }
}

//struct SingleSoundView_Previews: PreviewProvider {
//    static var previews: some View {
//        SingleSoundView()
//    }
//}
