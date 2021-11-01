//
//  TrendsView.swift
//  shonre
//
//  Created by Александр Шендрик on 01.10.2021.
//

import SwiftUI

struct TrendsView: View {
    @EnvironmentObject var DS : DataStorage
    
    @State var showPrePay : Bool = false
    
    var body: some View {
        ZStack{
            if !showPrePay {
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
                        TrendsDotsGraphComponent(tittle: "Sleep quality", subtittle:  AnyView(EmptyView()), chartParts: ChartPart.partsQuality, chartColumn: DS.soundAnalyzer.getSleepQualiti(), dividersInItem: 2)
                        
                        Spacer().frame(height: 100)
                        HStack{
                            Spacer()
                        }
                    }
                }.background(Color("Back").ignoresSafeArea()).blur(radius: 4).scaleEffect(1.11).offset(y: -10)
            } else {
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
                        TrendsDotsGraphComponent(tittle: "Sleep quality", subtittle:  AnyView(EmptyView()), chartParts: ChartPart.partsQuality, chartColumn: DS.soundAnalyzer.getSleepQualiti(), dividersInItem: 2)
                        
                        Spacer().frame(height: 100)
                        HStack{
                            Spacer()
                        }
                    }
                }.background(Color("Back").ignoresSafeArea())
            }
                
            if !showPrePay {
                VStack{
                    Spacer()
                    Text("Track your progress").foregroundColor(Color.white).font(.system(size: 28, weight: .semibold))
                    Text("Visualize your snoring changing over time and see the impact of remedies and factors").foregroundColor(Color.white).font(.system(size: 16)).multilineTextAlignment(.center).padding(.horizontal, 45).padding(.top, 20).padding(.bottom, 52)
                    ZStack{
                        RoundedRectangle(cornerRadius: 38).foregroundColor(Color("ButtonRed")).frame(height: 47)
                        Text("Upgrade").font(.system(size: 17)).foregroundColor(Color.white)
                    }.padding(.horizontal,80)
                    Spacer()
                    HStack{
                        Spacer()
                    }
                }.background(Color.black.opacity(0.7).ignoresSafeArea())
            }
        }.onAppear(perform: {
            self.showPrePay = !self.DS.apphudHelper.isPremium
        }).onReceive(self.DS.apphudHelper.$isPremium, perform: {val in
            self.showPrePay = !val
        })
    }
}

struct TrendsView_Previews: PreviewProvider {
    static var previews: some View {
        TrendsView()
    }
}
