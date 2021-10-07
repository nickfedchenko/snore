//
//  DataStorage.swift
//  shonre
//
//  Created by Александр Шендрик on 01.10.2021.
//

import Foundation

class DataStorage : ObservableObject {
    
    @Published var soundAnalyzer : SoundAnalyzer
    
    init() {
        self.soundAnalyzer = SoundAnalyzer()
    }
    
}
