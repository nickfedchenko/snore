//
//  OnboardingView.swift
//  whitesound
//
//  Created by Александр Шендрик on 09.09.2021.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var DS : DataStorage
    
    @Binding var isPresented : Bool
    @State var selected : Int
    @State var toggle : Bool = true
    
    @State var buttonLock : Bool = false
    
    
    @State var webView1 : Bool = false
    @State var webView2 : Bool = false
    @State var pwTittle : String = ""
    @State var showCross : Bool = false
    
    let buttonWith : CGFloat = 300
    
    var onboardingParts : [OnboardingPart] = OnboardingPart.data
    
    var body: some View {
        let pwText = DS.apphudHelper.getPayWallText()
        VStack{
            ZStack{
                ScrollView(.horizontal, showsIndicators: false){
                    ScrollViewReader { proxy in
                        ZStack {
                            HStack{
                                ForEach(0..<onboardingParts.count){ i in
                                    Spacer().id(i)
                                    Image(onboardingParts[i].img).resizable().aspectRatio(contentMode: .fit).frame(width: UIScreen.main.bounds.width)
                                }
                            }
                        }.onChange(of: selected, perform: { value in
                            withAnimation{
                                proxy.scrollTo(selected, anchor: UnitPoint(x: 0.0, y: UIScreen.main.bounds.height / 1.6))
                            }
                        }).onAppear(perform: {
                            proxy.scrollTo(selected)
                        })
                    }
                }.ignoresSafeArea().frame(height: UIScreen.main.bounds.height / 1.6).disabled(true)
                
                if showCross {
                    VStack{
                        HStack(alignment: .top){
                            Spacer()
                            Button(action: {
                                isPresented = false
                            }, label :{
                                ZStack{
                                    Circle().frame(width: 32, height: 32).foregroundColor(Color.white)
                                    Image("cross").renderingMode(.template).resizable().aspectRatio(contentMode: .fit).foregroundColor(.black).frame(width: 18, height: 18)
                                }
                            })
                        }.padding(.top,60).padding(.horizontal)
                        Spacer()
                    }
                }
            }
                
            Spacer()
            
            if selected + 1 != onboardingParts.count {
                Text(onboardingParts[selected].tittle).font(.system(size: 30, weight: .semibold)).multilineTextAlignment(.center).foregroundColor(Color.white)
                Text(onboardingParts[selected].text).font(.system(size: 20, weight: .medium)).multilineTextAlignment(.center).foregroundColor(Color.white.opacity(0.9)).padding(.horizontal, 48)
            } else {
                Text(DS.apphudHelper.Text1).font(.system(size: 30, weight: .semibold)).padding(.bottom, 13).multilineTextAlignment(.center).foregroundColor(Color.white)
                Text(DS.apphudHelper.Tittle1).font(.system(size: 14, weight: .medium)).foregroundColor(Color.white.opacity(0.9)).padding(.horizontal, 48).multilineTextAlignment(.center).frame(width: buttonWith)
                Spacer()
                Text(DS.apphudHelper.Price1.replacingOccurrences(of: "%free_time%", with: DS.apphudHelper.SKtrial_time1).replacingOccurrences(of: "%price%", with: DS.apphudHelper.SKprice1).replacingOccurrences(of: "%time%", with: DS.apphudHelper.SKtime1)).font(.system(size: 15, weight: .semibold)).foregroundColor(Color.white).multilineTextAlignment(.center).frame(width: buttonWith).onAppear{
                    pwTittle = DS.apphudHelper.pwTitleText
                }.onReceive(DS.apphudHelper.$pwTitleText){ val in
                    pwTittle = val
                }
            }
            
            Spacer()
            ZStack{
                RoundedRectangle(cornerRadius: 10).stroke(Color("ButtonRed"), lineWidth: 0.5).frame(width: buttonWith, height: 41)
                HStack{
                    Text("Animated enabled").foregroundColor(Color.white.opacity(0.9)).fixedSize()
                    Toggle("", isOn: $toggle).toggleStyle(SwitchToggleStyle(tint: Color("ButtonRed")))
                }.padding(14)
            }.fixedSize()
            
            Button(action: {
                if !buttonLock{
                    if selected + 1 < onboardingParts.count {
                        withAnimation{
                            selected += 1
                        }
                        buttonLock = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
                            buttonLock = false
                        }
                    } else {
                        if DS.apphudHelper.product != nil {
                            DS.apphudHelper.purchase(product: DS.apphudHelper.product!)
//                            DS.onboardingWasShown()
                        }
                    }
                    
                    // Уведомления
//                    if onboardingParts[selected].num == 1 {
//                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
//                        }
//                    }
                     
                }
                
            }){
                ZStack{
                    RoundedRectangle(cornerRadius: 10).foregroundColor(Color("ButtonRed")).frame(width: buttonWith ,height: 61)
                    Text(selected + 1 != onboardingParts.count ? onboardingParts[selected].buttonText : onboardingParts[selected].buttonText).foregroundColor(.white).font(.system(size: 21, weight: .semibold))
                }
            }
            
            HStack{
                ForEach(0..<onboardingParts.count){ i in
                    Circle().frame(width: 8, height: 8).foregroundColor(Color("ButtonRed").opacity(selected == i ? 1.0 : 0.5))
                }
            }
            
            if selected != onboardingParts.count - 1 {

            } else {
                HStack{
                    Spacer()
                    Button(action: {
                        webView1 = true
                    }){
                        Text("Privacy Policy").foregroundColor(.white.opacity(0.5)).font(.system(size: 12))
                    }
                    Spacer()
                    Button(action: {
                        webView2 = true
                    }){
                        Text("Terms of use").foregroundColor(.white.opacity(0.5)).font(.system(size: 12))
                    }
                    Spacer()
                }
            }
            Spacer().frame(height: 50)
        }.background(Color("Back").ignoresSafeArea()).sheet(isPresented: $webView1, content: {
            VStack{
                HStack{
                    Spacer()
                    Button(action: {
                        // Policy
                        webView1 = false
                    }, label: {
                        Image(systemName: "xmark").resizable().foregroundColor(Color.black).frame(width: 16, height: 16)
                    })
                }.padding().background(Color("AccentColor").ignoresSafeArea())
                WebView(type: .public, url: "https://docs.google.com/document/d/1DI1PYSlAYSLpm1A0ZpUbUJJd8JJ6BXUTzA7IGzzRazc/edit?usp=sharing").navigationBarItems(trailing: Button("Close"){
                    webView1 = false
                })
            }
        }).sheet(isPresented: $webView2, content: {
            VStack{
                HStack{
                    Spacer()
                    Button(action: {
                        webView2 = false
                    }, label: {
                        Image(systemName: "xmark").resizable().foregroundColor(Color.black).frame(width: 16, height: 16)
                    })
                }.padding().background(Color("AccentColor").ignoresSafeArea())
                WebView(type: .public, url: "https://docs.google.com/document/d/1JplDU3jZA-tpxDEW9gSlNsQGfQ3Mwg6c-eUJ9-P9gMg/edit?usp=sharing").navigationBarItems(trailing: Button("Close"){
                    webView2 = false
                })
            }
        }).onChange(of: selected, perform: {val in
            self.showCross = (DS.apphudHelper.curPayWallText.crossView || DS.isTest) && (val + 1 == onboardingParts.count)
        })
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(isPresented: .constant(true), selected: 0)
    }
}
