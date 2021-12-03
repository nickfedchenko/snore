//
//  PayWall2.swift
//  shonre
//
//  Created by Александр Шендрик on 24.11.2021.
//

import SwiftUI

struct PayWall2: View {
    @EnvironmentObject var DS : DataStorage
    @Binding var selectedProd : Int
    
    var body: some View {
        VStack{
            if UIScreen.main.bounds.width > 375 {
                Image("ob4").resizable().aspectRatio(contentMode: .fill).frame(width: UIScreen.main.bounds.width * 0.8)
            } else{
                VStack{
                    Image("ob4").resizable().aspectRatio(contentMode: .fill)
                }.frame(width: UIScreen.main.bounds.width * 0.8)
            }
            
            Text(DS.apphudHelper.curPayWallText2.text).foregroundColor(.white).font(.system(size: 30, weight: .bold)).multilineTextAlignment(.center).padding(.horizontal, 40)
            Text(DS.apphudHelper.curPayWallText2.title).foregroundColor(.white.opacity(0.5)).font(.system(size: 20)).multilineTextAlignment(.center).padding(.horizontal, 30)
            HStack(alignment: .bottom){
                if DS.apphudHelper.curPayWallText2.show1{
                VStack{
                        Button(action: {
                            selectedProd = 0
                        }){
                            ZStack{
                                RoundedRectangle(cornerRadius: 14).foregroundColor(Color("PWRed").opacity(selectedProd == 0 ? 1: 0.4))
                                VStack{
                                    Text(DS.apphudHelper.curPayWallText2.time1).foregroundColor(.white).font(.system(size: 28, weight: .semibold)).multilineTextAlignment(.center).fixedSize().padding(.top, 10)
                                    Text(DS.apphudHelper.skProdInfo21.price).foregroundColor(.white).font(.system(size: 11, weight: .semibold))
                                    Rectangle().foregroundColor(.black).frame(height:4)
                                    Text("\(DS.apphudHelper.skProdInfo21.week_price)/week").foregroundColor(.white).font(.system(size: 11, weight: .semibold)).padding(.bottom, 10)
                                }
                            }
                        }
                    }.frame(width: 100, height:135)
                }
                
                if DS.apphudHelper.curPayWallText2.show2{
                    VStack{
                        Button(action: {
                            selectedProd = 1
                        }){
                            ZStack{
                                RoundedRectangle(cornerRadius: 14).foregroundColor(Color("PWRed").opacity(selectedProd == 1 ? 1 : 0.4))
                                VStack{
                                    Text("BEST OFFER").foregroundColor(.white).font(.system(size: 11, weight: .semibold)).padding(.top, 10)
                                    Text(DS.apphudHelper.curPayWallText2.time2).foregroundColor(.white).font(.system(size: 28, weight: .semibold)).multilineTextAlignment(.center).fixedSize()
                                    Text(DS.apphudHelper.skProdInfo22.price).foregroundColor(.white).font(.system(size: 11, weight: .semibold))
                                    Rectangle().foregroundColor(.black).frame(height:4)
                                    Text("\(DS.apphudHelper.skProdInfo22.week_price)/week").foregroundColor(.white).font(.system(size: 11, weight: .semibold)).padding(.bottom, 10)
                                }
                            }
                        }
                    }.frame(width: 100, height:150).padding(.horizontal, 10)
                }
                
                if DS.apphudHelper.curPayWallText2.show3{
                    VStack{
                        Button(action: {
                            selectedProd = 2
                        }){
                            ZStack{
                                RoundedRectangle(cornerRadius: 14).foregroundColor(Color("PWRed").opacity(selectedProd == 2 ? 1 : 0.4))
                                VStack{
                                    Text(DS.apphudHelper.curPayWallText2.time3).foregroundColor(.white).font(.system(size: 28, weight: .semibold)).multilineTextAlignment(.center).fixedSize().padding(.top, 10)
                                    Text(DS.apphudHelper.skProdInfo23.price).foregroundColor(.white).font(.system(size: 11, weight: .semibold))
                                    Rectangle().foregroundColor(.black).frame(height:4)
                                    Text("\(DS.apphudHelper.skProdInfo23.week_price)/week").foregroundColor(.white).font(.system(size: 11, weight: .semibold)).padding(.bottom, 10)
                                }
                            }
                        }
                    }.frame(width: 100, height:135)
                }
            }.padding(.horizontal, 5)
        }.background(Color("Back")).frame(width: UIScreen.main.bounds.width)
    }
}

struct PayWall2_Previews: PreviewProvider {
    static var previews: some View {
        PayWall2(selectedProd: .constant(1))
    }
}
