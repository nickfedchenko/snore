//
//  SircleChartComponent.swift
//  shonre
//
//  Created by Александр Шендрик on 08.10.2021.
//

import SwiftUI

struct SircleChartComponent: View {
    var sound : Sound
    
    var body: some View {
        ZStack{
            Circle().trim(from: 0.0, to: CGFloat( Float(sound.timeNoSnoringPercentWhite))).foregroundColor(ColorType.White.getColor())
            Circle().trim(from: 0.0, to: CGFloat( Float(sound.timeNoSnoringPercentWhite))).foregroundColor(ColorType.Yellow.getColor())
            Circle().trim(from: 0.0, to: CGFloat( Float(sound.timeNoSnoringPercentWhite))).foregroundColor(ColorType.Red.getColor())
        }.frame(width: 112, height: 122)
    }
}

struct SircleChartComponent_Previews: PreviewProvider {
    static var previews: some View {
        SircleChartComponent(sound: Sound.data[0])
    }
}
