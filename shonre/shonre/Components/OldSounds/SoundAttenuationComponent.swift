//
//  SoundAttenuationComponent.swift
//  whitesound
//
//  Created by Александр Шендрик on 01.09.2021.
//

import SwiftUI

struct SoundAttenuationComponent: View {
    @ObservedObject var attenuation : AttenuationVM
    @State var showContent : Bool = false
    var backgroundColor : Color
    var textColor : Color
    var buttonBackColor : Color
    var buttonTextColor : Color
    var startColor : Color
    var lineColor : Color
    var backLineColor : Color
    var timeTextColor : Color
    
    var body: some View {
        VStack{
            HStack{
                Text("Attenuation").foregroundColor(textColor).font(.system(size: 18))
                Spacer()
                //TODO - смнеить цвета
                Toggle("", isOn: $attenuation.isOn).toggleStyle(SwitchToggleStyle(tint: Color("AccentColor"))).fixedSize()
            }
            if showContent {
                HStack(alignment: .center){
                    VStack(alignment: .leading){
                        Text("start's at").foregroundColor(startColor).font(.system(size: 14))
                        AttenuationSetterComponent(attenuation : attenuation, lineColor: lineColor, backLineColor: backLineColor, timeTextColor : timeTextColor)
                    }.padding(.trailing)
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 3).foregroundColor(buttonBackColor)
                        Text(attenuation.textLabel).foregroundColor(buttonTextColor).font(.system(size: 13))
                    }.frame(width: 67, height: 28)
                }
            }
        }.padding().background(backgroundColor).clipShape(RoundedRectangle(cornerRadius: 9)).onAppear{
            showContent = attenuation.isOn
        }.onReceive(attenuation.$isOn, perform: { val in
            withAnimation{
                self.showContent = val
            }
        })
    }
}

struct SoundAttenuationComponent_Previews: PreviewProvider {
    static var previews: some View {
        SoundAttenuationComponent(attenuation: AttenuationVM(), backgroundColor: Color.black.opacity(0.41), textColor: .white, buttonBackColor: .white, buttonTextColor: Color("AccentColor"), startColor: .white, lineColor : .white , backLineColor :.white.opacity(0.5), timeTextColor: .white.opacity(0.6))
        
    }
}

