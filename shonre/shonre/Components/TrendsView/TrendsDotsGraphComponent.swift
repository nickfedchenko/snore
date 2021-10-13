//
//  TrendsDotsGraphComponent.swift
//  shonre
//
//  Created by Александр Шендрик on 05.10.2021.
//

import SwiftUI

struct TrendsDotsGraphComponent: View {
    var tittle : String
    var subtittle : AnyView
    
    var chartParts : [ChartPart]
    var chartColumn : [ChartColumn]
    var dividersInItem : Int
    

    let pad : CGFloat = 26
    
    var body: some View {
        VStack{
            HStack{
                VStack(alignment: .leading){
                    Text(tittle).foregroundColor(.white).font(.system(size: 20, weight: .medium))
                    subtittle
                }
                Spacer()
            }
            ChartComponent(chartParts: chartParts, dividersInItem: dividersInItem, columns: AnyView(
                ZStack{
                    GeometryReader { proxy in
                        let wpadding = proxy.size.width / CGFloat(chartColumn.count)
                        let bpadding : Int  = Int(proxy.size.height / CGFloat(chartColumn.count))
                        
                        ForEach(chartColumn) { part in
                            ChartColumnComponent(legend: part.label, persent: part.percent, maxCharHeight: proxy.size.height).offset(x: wpadding * CGFloat(chartColumn.firstIndex(where: {$0.id == part.id})!), y: proxy.size.height * (1.0 - part.percent))
                            
                        }
                        
                        
                        Path { path in
                            for i in 0..<chartColumn.count {
                                path.addEllipse(in: CGRect(x: CGFloat(wpadding * CGFloat(i)), y: CGFloat(proxy.size.height * ( 1 - chartColumn[i].percent) - 10), width: 20, height: 20))
                            }
                        }.fill(Color.red).frame(height: proxy.size.height).offset(x: wpadding/4.0)
                        
                        Path { path in
                            for i in 0..<chartColumn.count {
                                
                                if i + 1 < chartColumn.count {
                                    path.move(to: CGPoint(x: CGFloat(wpadding * CGFloat(i)), y: CGFloat(proxy.size.height * ( 1 - chartColumn[i].percent)  + 10)))
                                    
                                    path.addLine(to: CGPoint(x: CGFloat(wpadding * CGFloat(i) + 10), y: CGFloat(proxy.size.height * ( 1 - chartColumn[i].percent) + 2)))
                                    path.addLine(to: CGPoint(x: CGFloat(wpadding * CGFloat(i+1) + 10), y: CGFloat(proxy.size.height * ( 1 - chartColumn[i+1].percent) + 2)))
                                    path.addLine(to: CGPoint(x: CGFloat(wpadding * CGFloat(i+1) + 10), y: CGFloat(proxy.size.height * ( 1 - chartColumn[i+1].percent) - 2)))
                                    path.addLine(to: CGPoint(x: CGFloat(wpadding * CGFloat(i) + 10), y: CGFloat(proxy.size.height * ( 1 - chartColumn[i].percent) - 2)))
                                }
                            }
                        }.fill(Color.red).frame(height: proxy.size.height).offset(x: wpadding/4.0)
                        
                    }
                }
            ))

        }.padding(10).background(Color("Plate")).clipShape(RoundedRectangle(cornerRadius: 10)).padding(.horizontal,15).padding(.vertical, 12.5)
    }
}

struct TrendsDotsGraphComponent_Previews: PreviewProvider {
    static var previews: some View {
        TrendsDotsGraphComponent(tittle : "Sleep Time", subtittle: AnyView(EmptyView()), chartParts: ChartPart.parts4h, chartColumn: ChartColumn.parts7, dividersInItem: 3)
    }
}


//if i + 1 < chartColumn.count {
//    path.move(to: CGPoint(x: CGFloat(wpadding * CGFloat(i)), y: CGFloat(proxy.size.height * ( 1 - chartColumn[i].percent) - 10)))
//    path.addLine(to: CGPoint(x: CGFloat(wpadding * CGFloat(i)), y: CGFloat(proxy.size.height * ( 1 - chartColumn[i].percent) - 10)))
//    path.addLine(to: CGPoint(x: CGFloat(wpadding * CGFloat(i+1)), y: CGFloat(proxy.size.height * ( 1 - chartColumn[i+1].percent) - 10)))
//}
