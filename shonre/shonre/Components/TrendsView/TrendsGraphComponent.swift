//
//  TrendsGraphComponent.swift
//  shonre
//
//  Created by Александр Шендрик on 01.10.2021.
//

import SwiftUI

struct TrendsGraphComponent: View {
    var chartParts : [ChartPart]
    var chartColumn : [ChartColumn]
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
                        ChartColumnComponent(legend: part.label, persent: part.percent, maxCharHeight: proxy.size.height).offset(x: wpadding * CGFloat(chartColumn.firstIndex(where: {$0.id == part.id})!), y: proxy.size.height * (1.0 - part.percent))
                    }
                }
            ))

        }.padding(10).background(Color("Plate")).clipShape(RoundedRectangle(cornerRadius: 10)).padding(.horizontal,15).padding(.vertical, 12.5)
    }
}

struct TrendsGraphComponent_Previews: PreviewProvider {
    static var previews: some View {
        TrendsGraphComponent(chartParts: ChartPart.parts4h, chartColumn: ChartColumn.parts7, dividersInItem: 3)
    }
}

//ZStack(alignment: .bottomTrailing){
//    VStack(alignment: .trailing){
//        HStack{
//            Text("12h").frame(width: 30)
//            Rectangle().frame(height: 2)
//        }.padding(.bottom)
//        HStack{
//            Text("10h").frame(width: 30)
//            Rectangle().frame(height: 2)
//        }.padding(.bottom)
//        HStack{
//            Text("8h").frame(width: 30)
//            Rectangle().frame(height: 2)
//        }.padding(.bottom)
//        HStack{
//            Text("6h").frame(width: 30)
//            Rectangle().frame(height: 2)
//        }.padding(.bottom)
//        HStack{
//            Text("4h").frame(width: 30)
//            Rectangle().frame(height: 2)
//        }.padding(.bottom)
//        HStack{
//            Text("2h").frame(width: 30)
//            Rectangle().frame(height: 2)
//        }.padding(.bottom)
//        
//        
//    }.padding().foregroundColor(Color("TextGray"))
//    
//    HStack(alignment: .bottom){
//        HStack(alignment: .bottom){
//            ChartColumnComponent(legend: "Mon", persent: 0.8)
//            Spacer()
//            ChartColumnComponent(legend: "Tue", persent: 0.8)
//            Spacer()
//            ChartColumnComponent(legend: "Wed", persent: 0.8)
//            Spacer()
//            ChartColumnComponent(legend: "Thu", persent: 0.8)
//        }.frame(width: 173).padding(.trailing)
//        
//        HStack(alignment: .bottom){
//            ChartColumnComponent(legend: "Fri", persent: 0.8)
//            Spacer()
//            ChartColumnComponent(legend: "Sat", persent: 0.8)
//            Spacer()
//            ChartColumnComponent(legend: "Sun", persent: 0.8)
//        }.frame(width: 122)
//    }.padding(.bottom, 20).padding(.trailing)
//}
