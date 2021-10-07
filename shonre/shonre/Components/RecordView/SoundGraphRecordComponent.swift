//
//  SoundGraphRecordComponent.swift
//  shonre
//
//  Created by Александр Шендрик on 05.10.2021.
//

import SwiftUI

struct SoundGraphRecordComponent: View {
    var sound : Sound
    
    @State var soundGraph : [SingleWave] = [SingleWave]()
    
    let count : Int = 50
    let width : CGFloat = 212.0
    let height : CGFloat = 34.0
    
    
    var body: some View {
        let step : CGFloat = width / 50.0
        
        Path{ path in
            path.move(to: CGPoint(x: 0.0, y: height / 2.0 + 1))
            path.addLine(to: CGPoint(x: 0.0, y: height / 2.0 + 1))
            path.addLine(to: CGPoint(x: width, y: height / 2.0 + 1))
            path.addLine(to: CGPoint(x: width, y: height / 2.0 - 1))
            path.addLine(to: CGPoint(x: 0.0, y: height / 2.0 - 1))
            
            for i in 0..<soundGraph.count {
                let curHeight : CGFloat = height * CGFloat(soundGraph[i].volume) / 2.0
                path.move(to: CGPoint(x: step * CGFloat(i) - 1, y: height / 2.0 - curHeight))
                path.addLine(to: CGPoint(x: step * CGFloat(i) - 1, y: height / 2.0 - curHeight))
                path.addLine(to: CGPoint(x: step * CGFloat(i) - 1, y: height / 2.0 + curHeight))
                path.addLine(to: CGPoint(x: step * CGFloat(i) + 1, y: height / 2.0 + curHeight))
                path.addLine(to: CGPoint(x: step * CGFloat(i) + 1, y: height / 2.0 - curHeight))
            }
            
            
        }.fill(Color.white).frame(width: width, height: height).onAppear{
            self.soundGraph = sound.getGraphWaves(count: count)
        }.onReceive(sound.$waves, perform: {val in
            self.soundGraph = sound.getGraphWaves(count: count)
        })
    }
}

struct SoundGraphRecordComponent_Previews: PreviewProvider {
    static var previews: some View {
        SoundGraphRecordComponent(sound: Sound.data[0])
    }
}
