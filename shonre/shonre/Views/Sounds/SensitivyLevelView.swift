//
//  SensitivyLevelView.swift
//  shonre
//
//  Created by Александр Шендрик on 12.10.2021.
//

import SwiftUI

struct SensitivyLevelView: View {
    @EnvironmentObject var DS : DataStorage
    
    
    @State var senseLevel : Double
    @Binding var isPresented : Bool
    @State var dBString : String = ""
    
    let maxHeight : Double = 102
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    isPresented = false
                }){
                    Text("Cancel").font(.system(size: 16, weight: .medium))
                }
                Spacer()
                Text("Sensitivy").font(.system(size: 20, weight: .medium))
                Spacer()
                Button(action: {
                    isPresented = false
                    DS.soundAnalyzer.setLevel(level: self.senseLevel)
                }){
                    Text("Done").font(.system(size: 16, weight: .medium))
                }
            }.foregroundColor(.white).padding()
            
            ZStack(alignment: .bottom){
                Image("senselevel").resizable().aspectRatio(contentMode: .fit)
                Rectangle().frame(height: 2).offset(y : -maxHeight * senseLevel).foregroundColor(Color("ButtonRed")).padding(.horizontal, 25)
            }.padding(.horizontal, 15).frame(height: maxHeight)
            
            VStack{
                HStack{
                    Text("Sensitivy").font(.system(size: 20, weight: .medium))
                    Spacer()
                    Text(dBString).font(.system(size: 20, weight: .medium))
                }.foregroundColor(Color.white).padding(.horizontal, 15)
                
                SenSelectorComponent(proggres: $senseLevel).padding(.horizontal, 15).onChange(of: senseLevel, perform: {val in
                    let lvl = Int(10 * senseLevel) - 5
                    let sign : String = lvl == 0 ? "" : (lvl > 0 ? "+" : "-")
                    dBString = "\(sign)\(lvl) dB"
                }).onAppear(perform: {
                    let lvl = Int(10 * senseLevel) - 5
                    let sign : String = lvl == 0 ? "" : (lvl > 0 ? "+" : "-")
                    dBString = "\(sign)\(lvl) dB"
                })
            }.padding(.vertical, 23).background(Color("SenseColor")).padding(.top, 25)
            
            Spacer()
            HStack{
                Spacer()
            }
        }.background(Color("MixerColor").ignoresSafeArea())
    }
}

//struct SensitivyLevelView_Previews: PreviewProvider {
//    static var previews: some View {
//        SensitivyLevelView()
//    }
//}
