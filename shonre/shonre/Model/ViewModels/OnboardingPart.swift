//
//  OnboardingPart.swift
//  shonre
//
//  Created by Александр Шендрик on 12.10.2021.
//

import Foundation
import SwiftUI

struct OnboardingPart {
    var tittle : LocalizedStringKey
    var text : LocalizedStringKey
    var buttonText : LocalizedStringKey = "Continue"
    var num : Int
    var img : String
}


extension OnboardingPart {
    static var data : [OnboardingPart] = [
        OnboardingPart(tittle: "Welcome", text: "Welcome the snore recording and tracking app", num: 0, img : "ob1"),
        OnboardingPart(tittle: "Placement", text: "Place device next to your bed. Keep the charger connected", num: 1, img : "ob2"),
        OnboardingPart(tittle: "Results", text: "Shows you when and how loudly you snored and lets you playback audio", num: 2, img : "ob3"),
        OnboardingPart(tittle: "Get insights about your snore", text: "You can test snoring remedies and lifestyle changes to try to reduce ", num: 3, img : "ob4"),
//        OnboardingPart(tittle: "Continue to Pro", text: "Combine any sounds, Customize for yourself, Create your library", buttonText: "Start Free Trial & Continue", num: 5),
    ]
}


