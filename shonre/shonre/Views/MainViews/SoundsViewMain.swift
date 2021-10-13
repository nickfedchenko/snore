//
//  SoundsView.swift
//  shonre
//
//  Created by Александр Шендрик on 01.10.2021.
//

import SwiftUI

struct SoundsViewMain: View {
    @EnvironmentObject var viewControll : ViewControll
    @EnvironmentObject var DS : DataStorage
    
    @State var showMixeBoard : Bool = true
    
    var body: some View {
        ZStack(alignment: .bottom){
            SoundsView(isPresented: .constant(true))
            
            if self.showMixeBoard {
                SoundPlayerBlackComponent(showMixer: $viewControll.possitionController).padding(.bottom, 70)
            }

        }.onReceive(DS.viewControll.$showMixeBoard, perform: { val in
            withAnimation{
                self.showMixeBoard = val
            }
            
        })
    }
}

//struct SoundsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SoundsView()
//    }
//}
