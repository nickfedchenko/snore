//
//  SettingsView.swift
//  shonre
//
//  Created by Александр Шендрик on 01.10.2021.
//

import SwiftUI
import MessageUI
import StoreKit

struct SettingsView: View {
    @EnvironmentObject var DS : DataStorage
    
    @State var showEmail : Bool = false
    @State var result: Result<MFMailComposeResult, Error>? = nil
    
    var body: some View {
        VStack{
            HStack{
                Text("Sounds").font(.system(size: 30)).foregroundColor(Color.white)
                Spacer()
            }.padding(.horizontal, 15).padding(.top, 30).padding(.bottom, 27)
            
            Group{
                HStack{
                    Text("App functions").foregroundColor(.white.opacity(0.7)).font(.system(size: 16))
                    Spacer()
                }.padding(.bottom, 22)
                
                Button(action: {
                    DS.apphudHelper.restore()
                }){
                    HStack{
                        Image("cart")
                        Text("Restore purchase")
                        Spacer()
                        Image("arrowright")
                    }
                }
                
                Rectangle().frame(height: 2).padding(.vertical, 16)
                
                Button(action: {
                    if MFMailComposeViewController.canSendMail() {
                        showEmail = true
                    }
                }){
                    HStack{
                        Image("mail")
                        Text("Сontact the developer")
                        Spacer()
                        Image("arrowright")
                    }
                }
                
            }.padding(.horizontal, 15).foregroundColor(.white)
            Spacer()
        }.background(Color("Back").ignoresSafeArea()).buttonStyle(PlainButtonStyle()).sheet(isPresented: $showEmail, content: {
            MailView(isShowing: self.$showEmail, result: self.$result)
        })
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
