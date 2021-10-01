//
//  ChartColumnComponent.swift
//  shonre
//
//  Created by Александр Шендрик on 01.10.2021.
//

import SwiftUI

struct ChartColumnComponent: View {
    
    var legend : LocalizedStringKey
    var persent : Double
    
    let maxCharHeight : CGFloat
    
    var body: some View {
        VStack{
            Rectangle().frame(width:16, height: maxCharHeight * persent).foregroundColor(.clear).background(LinearGradient(gradient: Gradient(colors: [.white.opacity(1.0), Color("ChartLegend").opacity(0.1)]), startPoint: .top, endPoint: .bottom))
            Text(legend).font(.system(size: 13, weight: .medium)).foregroundColor(Color("ChartLegend"))
        }.frame(width: 40)
    }
}

struct ChartColumnComponent_Previews: PreviewProvider {
    static var previews: some View {
        ChartColumnComponent(legend: "Mon", persent: 0.8, maxCharHeight: 224)
    }
}

//Color("Plate").opacity(0.3)
