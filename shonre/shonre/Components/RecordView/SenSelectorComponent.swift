//
//  SenSelectorComponent.swift
//  shonre
//
//  Created by Александр Шендрик on 13.10.2021.
//

import SwiftUI

struct SenSelectorComponent: View {
    @Binding var proggres : Double
    
    var body: some View {
        VStack{
            ZStack{
                GeometryReader{ proxy in
                    Capsule().fill(Color.white.opacity(0.3)).frame(width: proxy.size.width, height: 6)
                    Capsule().fill(Color("ButtonRed")).frame(width: proxy.size.width * CGFloat(proggres), height: 6)
                    Circle().frame(width: 21, height: 21).foregroundColor(Color.white).offset(x: proxy.size.width * CGFloat(proggres) - 10, y: -6).gesture(DragGesture().onChanged({ val in
                        let x = val.location.x
                        self.proggres = Double(x / proxy.size.width)
                        
                        if self.proggres <= 0 {
                            self.proggres = 0.0
                        }
                        
                        if self.proggres >= 1 {
                            self.proggres = 1
                        }
                    }).onEnded({ val in
                        let x = val.location.x
                        self.proggres = Double(x / proxy.size.width)
                        
                        if self.proggres <= 0 {
                            self.proggres = 0.0
                        }
                        
                        if self.proggres >= 1 {
                            self.proggres = 1
                        }
                    }))
                }
            }.frame(height:16)
            HStack {
                Text("-5").foregroundColor(Color.white).font(.system(size: 14, weight: .light))
                Spacer()
                Text("5").foregroundColor(Color.white).font(.system(size: 14, weight: .light))
            }
        }
    }
}

struct SenSelectorComponent_Previews: PreviewProvider {
    static var previews: some View {
        SenSelectorComponent(proggres: .constant(0.5))
    }
}
