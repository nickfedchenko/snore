//
//  ViewControll.swift
//  shonre
//
//  Created by Александр Шендрик on 12.10.2021.
//

import Foundation
import StoreKit
import Combine

class ViewControll: ObservableObject {
    @Published var showSoundsView : Bool = false
    
    @Published var showMixeBoard : Bool = false
    @Published var showPayWall : Bool = false
    @Published var showSaveMixe : Bool = false
    
    @Published var showOnboarding : Bool = true
    
    @Published var showAddSoundButton : Bool = true
    
    // Слайдовер
    @Published var showChooseTime : CardPosition = CardPosition.bottom
    @Published var possitionController : CardPosition = CardPosition.bottom
    
    var showRateApp : Int = 0
    var cancellables = Set<AnyCancellable>()
    
    init() {
        $possitionController.sink(receiveValue: {val in
            if val == .top {
                self.showRateApp += 1
                if self.showRateApp == 3 {
                    SKStoreReviewController.requestReview()
                }
            }
        }).store(in: &cancellables)
    }
    
}
