//
//  PlayAtTimeVM.swift
//  whitesound
//
//  Created by Александр Шендрик on 06.09.2021.
//

import Foundation

class PlayAtTimeVM: ObservableObject {
    @Published var isOn : Bool = false
    @Published var hour : Int = 9
    @Published var minutes : Int = 45
    
    init() {
        
    }
}
