//
//  SoundsView.swift
//  shonre
//
//  Created by Александр Шендрик on 01.10.2021.
//

import SwiftUI

struct SoundsViewMain: View {
    @EnvironmentObject var viewControll : ViewControll
    @EnvironmentObject var DS : DataStorage
    
    @State var showMixeBoard : Bool = true
    @State var isPremium : Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom){
            if isPremium {
                SoundsView(isPresented: .constant(true))
            } else {
                SoundsView(isPresented: .constant(true)).blur(radius: 4).scaleEffect(1.11).offset(y: -10)
            }
            
//            if self.showMixeBoard {
            SoundPlayerBlackComponent(showMixer: $viewControll.possitionController).padding(.bottom, UIScreen.main.bounds.width > 375 ? 70 : 30)
//            }
            
            if !isPremium {
                VStack{
                    Spacer()
                    Text("Combine sounds for sleeping").foregroundColor(Color.white).font(.system(size: 28, weight: .semibold))
                    Text("Visualize your snoring changing over time and see the impact of remedies and factors").foregroundColor(Color.white).font(.system(size: 16)).multilineTextAlignment(.center).padding(.horizontal, 45).padding(.top, 20).padding(.bottom, 52)
                    ZStack{
                        RoundedRectangle(cornerRadius: 38).foregroundColor(Color("ButtonRed")).frame(height: 47)
                        Button(action: {
                            DS.viewControll.showPayWall = true
                        }){
                            Text("Upgrade").font(.system(size: 17)).foregroundColor(Color.white)
                        }
                    }.padding(.horizontal,80)
                    Spacer()
                    HStack{
                        Spacer()
                    }
                }.background(Color.black.opacity(0.7).ignoresSafeArea())
            }
            
        }.onReceive(DS.viewControll.$showMixeBoard, perform: { val in
            withAnimation{
                self.showMixeBoard = val
            }
        }).onAppear(perform: {
            self.isPremium = self.DS.apphudHelper.isPremium// || DS.isTest
        }).onReceive(self.DS.apphudHelper.$isPremium, perform: {val in
            self.isPremium = val
        })
    }
}

//struct SoundsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SoundsView()
//    }
//}
