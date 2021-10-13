//
//  TrendsView.swift
//  shonre
//
//  Created by Александр Шендрик on 01.10.2021.
//

import SwiftUI

struct TrendsView: View {
    @EnvironmentObject var DS : DataStorage
    
    var body: some View {
        
        VStack{
            ScrollView{
                TrendsGraphComponent(tittle: "Sleep duration", subtittle:  AnyView(HStack{
                    Text(DS.soundAnalyzer.getAverageSleepTime()).foregroundColor(.white); Spacer()
                }), chartParts: ChartPart.parts12h, chartColumn: DS.soundAnalyzer.getSleepDuration(), dividersInItem: 2)
                TrendsGraphComponent(tittle: "Sleep time", subtittle:  AnyView(HStack{
                    Text("Go to bed").foregroundColor(.white); Spacer()
                }), chartParts: ChartPart.parts19to1h, chartColumn: DS.soundAnalyzer.getSleepTime(), dividersInItem: 1)
                TrendsColorGraphComponent(tittle: "Sleep duration", subtittle:  AnyView(HStack{
                    Circle().frame(width: 8, height: 8).foregroundColor(ColorType.White.getColor())
                    Text("Low").foregroundColor(Color.white).font(.system(size: 14))
                    
                    Circle().frame(width: 8, height: 8).foregroundColor(ColorType.Yellow.getColor()).padding(.leading, 30)
                    Text("Hight").foregroundColor(Color.white).font(.system(size: 14))
                    
                    Circle().frame(width: 8, height: 8).foregroundColor(ColorType.Red.getColor()).padding(.leading, 30)
                    Text("Loud").foregroundColor(Color.white).font(.system(size: 14))
                    Spacer()
                }), chartParts: ChartPart.parts12h, chartColumn: DS.soundAnalyzer.getSnoreScore(), dividersInItem: 2)
                TrendsDotsGraphComponent(tittle: "Sleep duration", subtittle:  AnyView(EmptyView()), chartParts: ChartPart.parts4h, chartColumn: ChartColumn.parts7, dividersInItem: 3)
                
                Spacer().frame(height: 100)
                HStack{
                    Spacer()
                }
            }
        }.background(Color("Back").ignoresSafeArea())
        
    }
}

struct TrendsView_Previews: PreviewProvider {
    static var previews: some View {
        TrendsView()
    }
}
