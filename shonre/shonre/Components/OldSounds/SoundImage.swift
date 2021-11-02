//
//  SoundImage.swift
//  whitesound
//
//  Created by Александр Шендрик on 07.09.2021.
//

import SwiftUI

struct SoundImage: View {
    @ObservedObject var sound : WhiteSound
    
    init(_ sound : WhiteSound) {
        self.sound = sound
    }
    
    var body: some View {
        VStack{
            if sound.uiImage != nil {
                Image(uiImage: sound.uiImage!).resizable().aspectRatio(contentMode: .fill)
            } else {
                Image("noimage").resizable().aspectRatio(contentMode: .fill)
            }
        }
    }
}

struct SoundImage_Previews: PreviewProvider {
    static var previews: some View {
        SoundImage(WhiteSound.data[0])
    }
}
