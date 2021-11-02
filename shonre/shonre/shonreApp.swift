//
//  shonreApp.swift
//  shonre
//
//  Created by Александр Шендрик on 30.09.2021.
//

import SwiftUI

@main
struct shonreApp: App {
    @ObservedObject var DS = DataStorage()
    
    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(DS).environmentObject(DS.viewControll)
        }
    }
}
