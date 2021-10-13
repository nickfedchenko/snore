//
//  ChartColorColumnComponent.swift
//  shonre
//
//  Created by Александр Шендрик on 01.10.2021.
//

import SwiftUI

struct ChartColorColumnComponent: View {
    var legend : LocalizedStringKey
    
    var segments : [ColorSegment]
    let maxCharHeight : CGFloat
    
    var body: some View {
        VStack(spacing: 0){
            VStack(spacing: 0){
                ForEach(segments){ segment in
                    Rectangle().frame(width:16, height: maxCharHeight * segment.percent).foregroundColor(getColor(segment.type)).padding(0)
                }
            }
            Text(legend).padding(.top, 5).font(.system(size: 13, weight: .medium)).foregroundColor(Color("ChartLegend"))
        }.frame(width: 40)
    }
    
    func getColor(_ type : ColorType) -> Color {
        switch type {
        case .Red:
            return Color.red
        case .Yellow:
            return Color.yellow
        case .White:
            return Color.white
        }
    }
}

//Rectangle().frame(width:16, height: maxCharHeight * persent).foregroundColor(.clear).background(LinearGradient(gradient: Gradient(colors: [.white.opacity(1.0), Color("ChartLegend").opacity(0.1)]), startPoint: .top, endPoint: .bottom))

struct ChartColorColumnComponent_Previews: PreviewProvider {
    static var previews: some View {
        ChartColorColumnComponent(legend: "Mon", segments: ColorSegment.col2, maxCharHeight: 224)
    }
}
