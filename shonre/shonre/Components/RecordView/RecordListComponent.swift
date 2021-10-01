//
//  RecordListComponent.swift
//  shonre
//
//  Created by Александр Шендрик on 01.10.2021.
//

import SwiftUI

struct RecordListComponent: View {
    var body: some View {
        VStack{
            HStack{
                Text("Recording 1").font(.system(size: 17, weight: .medium)).foregroundColor(.white)
                Spacer()
                Text("begin at 11:35 (40 sec)").font(.system(size: 14, weight: .thin)).foregroundColor(.white)
            }
            
            HStack{
                Image(systemName: "pause.circle.fill").resizable().aspectRatio(contentMode: .fit).foregroundColor(.white).frame(width: 34, height: 34)
                Image("testWave")
                Spacer()
                Image("ArrowDown")
            }.padding(.bottom, 25).padding(.top, 19)
            Divider()
        }.padding(.horizontal).padding(.top, 25)
    }
}

struct RecordListComponent_Previews: PreviewProvider {
    static var previews: some View {
        RecordListComponent()
    }
}
