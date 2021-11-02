//
//  AttenuationSetterComponent.swift
//  whitesound
//
//  Created by Александр Шендрик on 01.09.2021.
//

import SwiftUI

struct AttenuationSetterComponent: View {
    @ObservedObject var attenuation : AttenuationVM
    @State var proggres : Float = 60
    var lineColor : Color
    var backLineColor : Color
    var timeTextColor : Color
    
    var body: some View {
        VStack{
            ZStack{
                GeometryReader{ proxy in
                    Capsule().fill(backLineColor).frame(width: proxy.size.width, height: 6)
                    Capsule().fill(lineColor).frame(width: proxy.size.width * CGFloat(proggres) / 100, height: 6)
                    Circle().frame(width: 16, height: 16).foregroundColor(Color.white).offset(x: proxy.size.width * CGFloat(proggres) / 100 - 7, y: -3.5).gesture(DragGesture().onChanged({ val in
                        let x = val.location.x
                        
                        self.attenuation.startsOn = 60 * 30 * Float(x / proxy.size.width)
                        if self.attenuation.startsOn < 0 {
                            self.attenuation.startsOn = 0.0
                        }
                        if self.attenuation.startsOn > 60 * 30 {
                            self.attenuation.startsOn = 60 * 30
                        }
                        
                        self.proggres = self.attenuation.startsOn  / (60 * 30) * 100
                    }))
                }
            }.frame(height:16)
            HStack {
                Text(attenuation.textLabel2).foregroundColor(timeTextColor).font(.system(size: 14))
                Spacer()
                Text("30:00").foregroundColor(timeTextColor).font(.system(size: 14))
            }
        }
    }
}

//struct AttenuationSetterComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        AttenuationSetterComponent()
//    }
//}
