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
    
    @State var PWnum : Int = 2
    @State var selectedProd : Int = 1
    
    var onboardingParts : [OnboardingPart] = OnboardingPart.data
    
    var body: some View {
        VStack{
            ZStack{
                if selected != onboardingParts.count - 1 || PWnum == 0 {
                    ScrollView(.horizontal, showsIndicators: false){
                        ScrollViewReader { proxy in
                            ZStack {
                                HStack{
                                    ForEach(0..<onboardingParts.count){ i in
                                        Spacer().id(i)
                                        if i != onboardingParts.count - 1 {
                                            if UIScreen.main.bounds.width > 375 {
                                                    Image(onboardingParts[i].img).resizable().aspectRatio(contentMode: .fit).frame(width: UIScreen.main.bounds.width)
                                            } else {
                                                VStack{
                                                    Image(onboardingParts[i].img).resizable().aspectRatio(contentMode: .fit)
                                                }.frame(width: UIScreen.main.bounds.width)
                                            }
                                        } else{
                                            if PWnum == 0 {
                                                if UIScreen.main.bounds.width > 375 {
                                                        Image(onboardingParts[i].img).resizable().aspectRatio(contentMode: .fit).frame(width: UIScreen.main.bounds.width)
                                                } else {
                                                    VStack{
                                                        Image(onboardingParts[i].img).resizable().aspectRatio(contentMode: .fit)
                                                    }.frame(width: UIScreen.main.bounds.width)
                                                }
                                            }
                                        }
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
                    }.ignoresSafeArea().frame(height: UIScreen.main.bounds.width > 375 ? UIScreen.main.bounds.height / 1.9 : UIScreen.main.bounds.height / 2.2).disabled(true)
                }
                
                if selected == onboardingParts.count - 1 && PWnum == 1 {
                    PayWall2(selectedProd: $selectedProd).padding(.bottom, 20)
                }
                
                if selected == onboardingParts.count - 1 && PWnum == 2 {
                    Spacer()
                    PayWall3(selectedProd: $selectedProd).padding(.bottom, 10)
                }
                
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
                        }.padding(.top, UIScreen.main.bounds.width > 375 ? 60 : 100).padding(.horizontal)
                        Spacer()
                    }
                }
            }
                
            if UIScreen.main.bounds.width > 375 {
                Spacer()
            }
            
            if selected + 1 != onboardingParts.count {
                Text(onboardingParts[selected].tittle).font(.system(size: 30, weight: .semibold)).multilineTextAlignment(.center).foregroundColor(Color.white)
                Text(onboardingParts[selected].text).font(.system(size: 20, weight: .medium)).multilineTextAlignment(.center).foregroundColor(Color.white.opacity(0.9)).padding(.horizontal, 48)
            } else {
                if PWnum == 0 {
                    Text(DS.apphudHelper.Text1).font(.system(size: UIScreen.main.bounds.width > 375 ? 30 : 20, weight: .semibold)).padding(.bottom, 13).multilineTextAlignment(.center).foregroundColor(Color.white)
                    Text(DS.apphudHelper.Tittle1).font(.system(size: UIScreen.main.bounds.width > 375 ? 14 : 12, weight: .medium)).foregroundColor(Color.white.opacity(0.9)).padding(.horizontal, 48).multilineTextAlignment(.center).frame(width: buttonWith)
                    Spacer()
                    Text(DS.apphudHelper.Price1.replacingOccurrences(of: "%free_time%", with: DS.apphudHelper.SKtrial_time1).replacingOccurrences(of: "%price%", with: DS.apphudHelper.SKprice1).replacingOccurrences(of: "%time%", with: DS.apphudHelper.SKtime1)).font(.system(size: UIScreen.main.bounds.width > 375 ? 15 : 12, weight: .semibold)).foregroundColor(Color.white).multilineTextAlignment(.center).frame(width: buttonWith).onAppear{
                        pwTittle = DS.apphudHelper.pwTitleText
                    }.onReceive(DS.apphudHelper.$pwTitleText){ val in
                        pwTittle = val
                    }
                }
            }
            
            Spacer()
            if selected != onboardingParts.count - 1 || PWnum == 0 {
                ZStack{
                    RoundedRectangle(cornerRadius: 10).stroke(Color("ButtonRed"), lineWidth: 0.5).frame(width: buttonWith, height: 41)
                    HStack{
                        Text("Animated enabled").foregroundColor(Color.white.opacity(0.9)).fixedSize()
                        Toggle("", isOn: $toggle).toggleStyle(SwitchToggleStyle(tint: Color("ButtonRed")))
                    }.padding(14)
                }.fixedSize()
            }
            
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
                        if selected == 1 {
                            DS.NCH.request()
                        }
                    } else {
                        if PWnum == 0 {
                            DS.apphudHelper.quickPurchase()
                        } else {
                            DS.apphudHelper.quickPurchase(selectedProd: selectedProd)
                        }
                    }
                }
                
            }){
                ZStack{
                    RoundedRectangle(cornerRadius: 10).foregroundColor(selected != onboardingParts.count - 1 || PWnum != 2 ? Color("ButtonRed") : Color("PWBlue")).frame(width: buttonWith ,height: 61)
                    Text(selected + 1 != onboardingParts.count ? onboardingParts[selected].buttonText : onboardingParts[selected].buttonText).foregroundColor(.white).font(.system(size: 21, weight: .semibold))
                }
            }
            
            HStack{
                ForEach(0..<onboardingParts.count){ i in
                    Circle().frame(width: 8, height: 8).foregroundColor((selected != onboardingParts.count - 1 || PWnum != 2 ? Color("ButtonRed") : Color("PWBlue")).opacity(selected == i ? 1.0 : 0.5))
                }
            }
            
            if selected != onboardingParts.count - 1 {

            } else {
                HStack{
                    Spacer()
                    Button(action: {
                        webView1 = true
                    }){
                        Text("Privacy Policy").foregroundColor(.white.opacity(0.5)).font(.system(size: 14))
                    }
                    Spacer()
                    Button(action: {
                        webView2 = true
                    }){
                        Text("Terms of use").foregroundColor(.white.opacity(0.5)).font(.system(size: 14))
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
                WebView(type: .public, url: "https://docs.google.com/document/d/1qprQFEVC0N4lmjQbG6dulR46dlLvubipgPFN3DVeUZU/edit?usp=sharing").navigationBarItems(trailing: Button("Close"){
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
                WebView(type: .public, url: "https://docs.google.com/document/d/1XrVvc_vh2NGm_nHv2kYCRh5vaEFiPJFiZJGh-lP_ceg/edit?usp=sharing").navigationBarItems(trailing: Button("Close"){
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
