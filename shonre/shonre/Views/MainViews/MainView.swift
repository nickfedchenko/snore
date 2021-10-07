//
//  MainView.swift
//  shonre
//
//  Created by Александр Шендрик on 01.10.2021.
//

import SwiftUI
import Introspect

struct MainView: View {
    
    @State var selectedTab : Int = 1
    
    var body: some View {
        ZStack(alignment: .bottom){
            VStack{
                TabView(selection : $selectedTab){
                    RecordView().tag(1)
                    ResultsView().tag(2)
                    TrendsView().tag(3)
                    SoundsView().tag(4)
                    SettingsView().tag(5)
                }.introspectTabBarController { (UITabBarController) in
                    UITabBarController.tabBar.isHidden = true
                }
                Spacer().frame(height: 70)
                
            }.background(Color("Back")).frame(height: UIScreen.main.bounds.height)
            
            VStack{
                HStack(alignment: .top){
                    BottomBarItem(tittle: "Record", imgName: "RecordBar", num: 1, selected: $selectedTab)
                    Spacer()
                    BottomBarItem(tittle: "Results", imgName: "ResultsBar", num: 2, selected: $selectedTab)
                    Spacer()
                    BottomBarItem(tittle: "Trends", imgName: "TrendsBar", num: 3, selected: $selectedTab)
                    Spacer()
                    BottomBarItem(tittle: "Sounds", imgName: "SoundsBar", num: 4, selected: $selectedTab)
                    Spacer()
                    BottomBarItem(tittle: "Settings", imgName: "SettingsBar", num: 5, selected: $selectedTab)
                }.padding(.top, 18)
                Spacer()
            }.padding(.horizontal, 29).frame(height: 105).background(Color("Back")).clipShape(RoundedRectangle(cornerRadius: 30)).shadow(color: .black.opacity(0.07), radius:37, x: 0, y: -7)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
