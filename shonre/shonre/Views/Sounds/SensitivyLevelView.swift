//
//  SensitivyLevelView.swift
//  shonre
//
//  Created by Александр Шендрик on 12.10.2021.
//

import SwiftUI

struct SensitivyLevelView: View {
    var player : SingleWaveSoundPlayer = SingleWaveSoundPlayer.data[0]
    
    @Binding var senseLevel : Double
    @State var dBString : String = ""
    
    let maxHeight : Double = 102
    
    var body: some View {
        VStack{
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
                    dBString = "\( Int(10 * senseLevel) - 5)dB"
                }).onAppear(perform: {
                    dBString = "\( Int(10 * senseLevel) - 5)dB"
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
