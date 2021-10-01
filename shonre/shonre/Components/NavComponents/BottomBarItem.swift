//
//  BottomBarItem.swift
//  shonre
//
//  Created by Александр Шендрик on 01.10.2021.
//

import SwiftUI
import Amplitude

struct BottomBarItem: View {
    var tittle : LocalizedStringKey
    var imgName : String
    var num : Int
    @Binding var selected : Int
    
    var body: some View {
        Button(action : {
            withAnimation{
                selected = num
            }
        }){
            VStack{
                Image(imgName).renderingMode(.template).resizable().aspectRatio(contentMode: .fit).frame(width: 24, height: 24).foregroundColor(selected == num ? Color("AccentColor") : Color("TextGray"))
                Text(tittle).font(.system(size: 10)).foregroundColor(selected == num ? Color("AccentColor") : Color("TextGray"))
            }
        }
    }
}

struct BottomBarItem_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarItem(tittle: "Home", imgName: "home", num: 0, selected: .constant(0))
    }
}
