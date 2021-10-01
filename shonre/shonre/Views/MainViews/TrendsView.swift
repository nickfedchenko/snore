//
//  TrendsView.swift
//  shonre
//
//  Created by Александр Шендрик on 01.10.2021.
//

import SwiftUI

struct TrendsView: View {
    var body: some View {
        VStack{
            ScrollView{
                TrendsGraphComponent(chartParts: ChartPart.parts4h, chartColumn: ChartColumn.parts7, dividersInItem: 3)
                TrendsGraphComponent(chartParts: ChartPart.parts12h, chartColumn: ChartColumn.parts6, dividersInItem: 2)
                TrendsColorGraphComponent(chartParts: ChartPart.parts12h, chartColumn: ChartColorColumn.part3, dividersInItem: 2)
                Spacer()
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
