//
//  ChartComponent.swift
//  shonre
//
//  Created by Александр Шендрик on 01.10.2021.
//

import SwiftUI

struct ChartComponent: View {
    
    var chartParts : [ChartPart]// = ChartPart.parts4h
//    var chartColumn : [ChartColumn]// = ChartColumn.parts7
    var dividersInItem : Int// = 3
    
    var columns : AnyView
    
    let maxCharHeight : CGFloat = 224.0
    
    var body: some View {
        
        let linesCount = (chartParts.count - 1) * (dividersInItem) + 1
        let bpadding : Int  = Int(maxCharHeight / CGFloat(linesCount))
        
        ZStack(alignment: .bottomLeading){
            HStack(alignment: .center){
                
                Spacer()
                ZStack(alignment: .top){
                    ForEach(chartParts){part in
                        let i = chartParts.firstIndex(where: {$0.id == part.id})!
                        Text(part.label).font(.system(size: 11)).foregroundColor(Color("ChartLegend")).frame(width: 24, height: 14).offset(y: CGFloat(dividersInItem * i * bpadding) - maxCharHeight / 2)
                    }
                }.frame(width: 20, height: maxCharHeight).offset(x: 20)
                
                ZStack{
                    VStack{
                        Spacer()
                        GeometryReader{ proxy in
                            Path { path in
                                for i in 0..<linesCount {
                                    path.move(to: CGPoint(x: 20, y: CGFloat(i * bpadding)))
                                    path.addLine(to: CGPoint(x: proxy.size.width, y: CGFloat(i * bpadding)))
                                    path.addLine(to: CGPoint(x: proxy.size.width, y: CGFloat(i * bpadding + 2)))
                                    path.addLine(to: CGPoint(x: 20, y: CGFloat(i * bpadding + 2)))
                                }
                            }.fill(Color("ChartLegend")).frame(height: maxCharHeight)
                        }
                        Spacer()
                    }.frame(height: maxCharHeight + CGFloat(bpadding))
                    
                    ZStack(alignment: .bottom){
                        columns
                    }.frame(height: CGFloat( (linesCount - 1) * bpadding)).padding(.bottom, 20).padding(.leading, 20)
                }
            }
        }
    }
}

struct ChartComponent_Previews: PreviewProvider {
    static var previews: some View {
        let chartColumn = ChartColumn.parts7
        ChartComponent(chartParts: ChartPart.parts4h, dividersInItem: 3, columns: AnyView(
            GeometryReader { proxy in
                let wpadding = proxy.size.width / 7
                ForEach(chartColumn) { part in
                    ChartColumnComponent(legend: part.label, persent: part.percent, maxCharHeight: proxy.size.height).offset(x: wpadding * CGFloat(chartColumn.firstIndex(where: {$0.id == part.id})!), y: proxy.size.height * (1.0 - part.percent))
                }
            }
        ))
    }
}



//ZStack(alignment: .bottom){
//    GeometryReader { proxy in
//        let wpadding = proxy.size.width / 7
//        ForEach(chartColumn) { part in
//            ChartColumnComponent(legend: part.label, persent: part.persent, maxCharHeight: proxy.size.height).offset(x: wpadding * CGFloat(chartColumn.firstIndex(where: {$0.id == part.id})!), y: proxy.size.height * (1.0 - part.persent))
//        }
//    }
//}.frame(height: CGFloat( (linesCount - 1) * bpadding)).padding(.bottom, 20).padding(.leading, 20)
