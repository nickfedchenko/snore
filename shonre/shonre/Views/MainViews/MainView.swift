//
//  MainView.swift
//  shonre
//
//  Created by Александр Шендрик on 01.10.2021.
//

import SwiftUI
import Introspect

struct MainView: View {
    @EnvironmentObject var viewControll : ViewControll
    @EnvironmentObject var DS : DataStorage
    
    @State var showSaveMixe : Bool = false
    @State var soundAnalyzerFilter : Bool = false
    
    @State var selectedTab : Int = 1
    
    
    var body: some View {
        ZStack(alignment: .bottom){
            VStack{
                TabView(selection : $selectedTab){
                    RecordView().tag(1)
                    ResultsView().tag(2)
                    TrendsView().tag(3)
                    SoundsViewMain().tag(4)
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
            }.padding(.horizontal, 29).frame(height: UIScreen.main.bounds.width > 375 ? 105 : 80).background(Color("Back")).shadow(color: .black.opacity(0.07), radius:37, x: 0, y: -7)
            
            SlideOverCard(possitionController: $viewControll.possitionController){
                MixerView(possitionController: $viewControll.possitionController)
            }.frame(width: UIScreen.main.bounds.width)
            
            SlideOverCard(possitionController: $viewControll.showChooseTime){
                ChooseStopTimeComponent(possitionController: $viewControll.showChooseTime, stopPlay: DS.soundStack.soundPlayer.stopPlay)
            }.frame(width: UIScreen.main.bounds.width)
            
            SlideOverCard(possitionController: $viewControll.possitionFilter){
                VStack{
                    Capsule().frame(width: 76, height: 5).foregroundColor(.white.opacity(0.2)).padding(.top, 10)
                    Text("Filter sound").foregroundColor(.white).font(.system(size: 24))
                    
                    HStack{
                        Button(action: {
                            DS.soundAnalyzer.filter = false
                        }){
                            Text("Запись всех звуков").foregroundColor(.white).font(.system(size: 21))
                            Spacer()
                            Image(!soundAnalyzerFilter ? "filteron" : "filteroff")
                        }
                    }.padding(.horizontal)
                    Divider()
                    HStack{
                        Button(action: {
                            DS.soundAnalyzer.filter = true
                        }){
                            Text("Только храп").foregroundColor(.white).font(.system(size: 21))
                            Spacer()
                            Image(soundAnalyzerFilter ? "filteron" : "filteroff")
                        }
                    }.padding(.horizontal)
                    Spacer()
                }.background(Color("MixerColor"))
            }.frame(width: UIScreen.main.bounds.width).onAppear(perform: {
                soundAnalyzerFilter = DS.soundAnalyzer.filter
            }).onReceive(DS.soundAnalyzer.$filter, perform: {val in
                soundAnalyzerFilter = val
            })
            
            if showSaveMixe {
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        AddMixeComponent(soundPlayer: DS.soundStack.soundPlayer, isPresented: $DS.viewControll.showSaveMixe)
                        Spacer()
                    }
                    Spacer()
                }.background(Color.black.opacity(0.2)).ignoresSafeArea()
            }
            
            if viewControll.showOnboarding {
                OnboardingView(isPresented: $viewControll.showOnboarding, selected: 0)
            }
            
            if viewControll.showPayWall {
                OnboardingView(isPresented: $viewControll.showPayWall, selected: OnboardingPart.data.count - 1)
            }
        }.onReceive(DS.viewControll.$showSaveMixe, perform: { val in
            withAnimation{
                self.showSaveMixe = val
            }
        })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
