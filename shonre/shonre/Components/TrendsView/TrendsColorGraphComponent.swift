//
//  TrendsColorGraphComponent.swift
//  shonre
//
//  Created by Александр Шендрик on 01.10.2021.
//

import SwiftUI

struct TrendsColorGraphComponent: View {
    var chartParts : [ChartPart]
    var chartColumn : [ChartColorColumn]
    var dividersInItem : Int
    

    let pad : CGFloat = 26
    
    var body: some View {
        VStack{
            HStack{
                VStack(alignment: .leading){
                    Text("Sleep Time").foregroundColor(.white).font(.system(size: 20, weight: .medium))
                    Text("Average is 7 hrs 21 min").foregroundColor(.white).font(.system(size: 16, weight: .light))
                }
                Spacer()
            }
            ChartComponent(chartParts: chartParts, dividersInItem: dividersInItem, columns: AnyView(
                GeometryReader { proxy in
                    let wpadding = proxy.size.width / CGFloat(chartColumn.count)
                    ForEach(chartColumn) { part in
                        ChartColorColumnComponent(legend: part.label, segments: part.segments, maxCharHeight: proxy.size.height).offset(x: wpadding * CGFloat(chartColumn.firstIndex(where: {$0.id == part.id})!), y: proxy.size.height * (1.0 - part.percent()))
                    }
                }
            ))

        }.padding(10).background(Color("Plate")).clipShape(RoundedRectangle(cornerRadius: 10)).padding(.horizontal,15).padding(.vertical, 12.5)
    }
}

struct TrendsColorGraphComponent_Previews: PreviewProvider {
    static var previews: some View {
        TrendsColorGraphComponent(chartParts: ChartPart.parts4h, chartColumn: ChartColorColumn.part3, dividersInItem: 3)
    }
}
