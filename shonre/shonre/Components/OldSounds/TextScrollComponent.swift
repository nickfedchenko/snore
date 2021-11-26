//
//  TextScrollComponent.swift
//  whitesound
//
//  Created by Александр Шендрик on 02.09.2021.
//

import SwiftUI
import Amplitude
import Lottie

struct TextScrollComponent: View {
    let types : [SoundTypeList] = SoundTypeList.data
    @State var selected : SoundType = .All
    @Binding var selectedInt : Int
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                ForEach(types){type in
                    Button(action: {
                        selectedInt = types.firstIndex(where: {$0.type == type.type})!
                        selected = type.type
                    }){
                        VStack{
                            Text(type.text).font(.system(size: 15)).foregroundColor(.white).padding(.horizontal).padding(.leading,  type.type == .All ? 20 : 0)
                            Rectangle().frame(height: 2).padding(.horizontal, 10).foregroundColor(selected == type.type ? Color("ButtonRed") : Color("Back")).padding(.leading,  type.type == .All ? 20 : 0)
                        }
                    }
                }
            }.onChange(of: selectedInt, perform: { val in
                self.selected = types[val].type
            })
        }.buttonStyle(PlainButtonStyle())
    }
}

struct TextScrollComponent_Previews: PreviewProvider {
    static var previews: some View {
        TextScrollComponent(selectedInt: .constant(0))
    }
}
