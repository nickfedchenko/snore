//
//  ChooseStopTimeComponent.swift
//  whitesound
//
//  Created by Александр Шендрик on 11.09.2021.
//

import SwiftUI

struct ChooseStopTimeComponent: View {
    @Binding var possitionController : CardPosition
    @ObservedObject var stopPlay : StopPlayVM

    @State var setHour : Int = 0
    @State var setMin : Int = 0

    var hourText : String
    var minText : String

    init(possitionController : Binding<CardPosition>, stopPlay : StopPlayVM) {
        self._possitionController = possitionController
        self.stopPlay = stopPlay
        
        var nhourText = ""
        var hminText = ""
        
        let langStr = Locale.current.languageCode
        if langStr == "ru" {
            nhourText = "час"
            hminText = "мин."
        } else {
            nhourText = "hour"
            hminText = "min."
        }
        
        self.hourText = nhourText
        self.minText = hminText
    }
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button(action: {
                    possitionController = .bottom
                }){
                    Image("arrowdown")
                }
            }.padding(.horizontal).padding(.top, 30)
            Text("How long do you want the sound to play?").font(.system(size: 18)).foregroundColor(.white)

            HStack{
                Spacer()
                Picker(selection: $setHour, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                    ForEach(0...23, id: \.self){ i in
                        Text(i == setHour ? "\(i) \(hourText)" : "\(i)").tag(i).foregroundColor(.white)
                    }
                }.frame(width: UIScreen.main.bounds.width / 2.0 - 50).clipped().offset(x: 4)
                Picker(selection: $setMin, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                    ForEach(0...59, id: \.self){ i in
                        Text(i == setMin ? "\(i) \(minText)" : "\(i)").tag(i).foregroundColor(.white)
                    }
                }.frame(width: UIScreen.main.bounds.width / 2.0 - 50).clipped().offset(x: -4)
                Spacer()
            }.frame(width: UIScreen.main.bounds.width - 100).clipped()

            Button(action:{
                stopPlay.sHours = self.setHour
                stopPlay.sMinutes = self.setMin
                possitionController = .bottom
            }){
                ZStack{
                    RoundedRectangle(cornerRadius: 38).foregroundColor(Color("ButtonRed")).frame(height: 47)
                    Text("Ready").foregroundColor(.white).font(.system(size: 17))
                }.padding(.horizontal, 64)
            }

            Button(action:{
                stopPlay.sHours = 0
                stopPlay.sMinutes = 0
                possitionController = .bottom
            }){
                Text("Cancel").foregroundColor(.white).font(.system(size: 17))
            }.padding(.bottom, 20)
            Spacer()
        }.background(Color("MixerColor"))
    }
}

struct ChooseStopTimeComponent_Previews: PreviewProvider {
    static var previews: some View {
        ChooseStopTimeComponent(possitionController: .constant(.middle), stopPlay: StopPlayVM())
    }
}
