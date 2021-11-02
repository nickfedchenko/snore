//
//  AddMixeComponent.swift
//  whitesound
//
//  Created by Александр Шендрик on 11.09.2021.
//

import SwiftUI

struct AddMixeComponent: View {
    @EnvironmentObject var DS : DataStorage
    @ObservedObject var soundPlayer : SoundPlayer
    @Binding var isPresented : Bool
    @State var selectedCathegory : Int = 0
    @State var toPublic : Bool = false
    
    var body: some View {
        VStack{
            ZStack(alignment: Alignment(horizontal: .center, vertical: .center)){
                HStack{
                    Spacer()
                    Button(action: {
                        isPresented = false
                    }){
                        Image("cross").renderingMode(.template).resizable().aspectRatio(contentMode: .fit).foregroundColor(.white).frame(width: 16, height: 16)
                    }
                }
                Text("Tittle").font(.system(size: 15)).foregroundColor(.white)
            }.padding(.horizontal, 18)
            VStack{
            }.frame(height:72).padding(.horizontal,30)
            VStack{
                TextField("Name", text: $soundPlayer.mixeName).font(.system(size: 15)).padding(.vertical,5).foregroundColor(.white)
                Divider()
//                HStack{
//                    Text("Category").font(.system(size: 15))
//                    Spacer()
//                }.padding(.top, 5)
                
//                Picker(selection: $soundPlayer.mixeType, label: Text("Category")) {
//                    ForEach(MixeTypeList.data){type in
//                        Text(type.type.name()).font(.system(size: 15)).tag(type).clipped()
//                    }
//                }.padding(.horizontal, 30).frame(width: 220, height: 42).clipShape(RoundedRectangle(cornerRadius: 10))
                
            }.padding(.horizontal,30)
            
            
            
            Button(action: {
                DS.soundStack.saveMixe(toPublic: toPublic)
                isPresented = false
            }){
                ZStack{
                    RoundedRectangle(cornerRadius: 6).foregroundColor(Color("ButtonRed"))
                    Text("Save Mix").foregroundColor(.white).font(.system(size: 17))
                }.frame(height: 48).padding(.horizontal,30)
            }
        }.padding().background(Color("Plate")).frame(width: 305).clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct AddMixeComponent_Previews: PreviewProvider {
    static var previews: some View {
        AddMixeComponent(soundPlayer : SoundPlayer(), isPresented: .constant(true))
    }
}

//Picker(selection: $selectedCathegory, label: EmptyView()) {
//    ForEach(0..<MixeTypeList.data.count, id: \.self){i in
//        Text(MixeTypeList.data[i].type.name()).font(.system(size: 15)).tag(i)
//    }
//}.frame(height: 60).clipped()
