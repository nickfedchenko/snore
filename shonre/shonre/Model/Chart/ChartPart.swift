//
//  ChartPart.swift
//  shonre
//
//  Created by Александр Шендрик on 01.10.2021.
//

import Foundation
import SwiftUI

struct ChartPart : Identifiable {
    var label : LocalizedStringKey
    var id = UUID()
}

struct ChartColumn : Identifiable {
    var label : LocalizedStringKey
    var percent : Double
    var id = UUID()
}

struct ChartColorColumn : Identifiable {
    var label : LocalizedStringKey
    var segments : [ColorSegment]
    var id = UUID()
    
    func percent() -> Double {
        var out : Double = 0.0
        
        for segment in segments {
            out += segment.percent
        }
        
        return out
    }
}

struct ColorSegment : Identifiable{
    var percent : Double
    var type : ColorType
    var id = UUID()
}

enum ColorType : String {
    case Red = "Red"
    case Yellow = "Yellow"
    case White = "White"
    
    func getColor() -> Color {
        switch self {
        case .Red:
            return Color.red
        case .Yellow:
            return Color.yellow
        case .White:
            return Color.white
        }
    }
    
    func getTextColor() -> Color {
        switch self {
        case .Red:
            return Color.black
        case .Yellow:
            return Color.black
        case .White:
            return Color.black
        }
    }
    
    init(volume: Float){
        if volume < 0.1 {
            self = .White
            return
        }
        
        if volume < 0.2 {
            self = .Yellow
            return
        }
        if volume > 0.3 {
            self = .Red
            return
        }
        self = .White
    }
    
    init(volume: Float, level : Double){
        let delta : Float = 1 * Float(level - 0.5) 
        if volume < 0.1 + delta {
            self = .White
            return
        }
        
        if volume < 0.2 + delta {
            self = .Yellow
            return
        }
        if volume > 0.3 + delta {
            self = .Red
            return
        }
        self = .White
    }
}

extension ChartPart {
    static var parts12h : [ChartPart] = [ChartPart(label: "12h"), ChartPart(label: "10h"), ChartPart(label: "8h"), ChartPart(label: "6h"), ChartPart(label: "4h"), ChartPart(label: "2h"), ChartPart(label: "0h")]
    
    static var parts4h : [ChartPart] = [ChartPart(label: "4h"), ChartPart(label: "3h"), ChartPart(label: "2h"), ChartPart(label: "1h"), ChartPart(label: "0h")]
    
    static var partsQuality : [ChartPart] = [ChartPart(label: "10"), ChartPart(label: "8"), ChartPart(label: "6"), ChartPart(label: "4"), ChartPart(label: "2"), ChartPart(label: "0")]
    
    static var parts19to1h : [ChartPart] = [ChartPart(label: "19h"), ChartPart(label: "20h"), ChartPart(label: "21h"), ChartPart(label: "22h"), ChartPart(label: "23h"), ChartPart(label: "24h"), ChartPart(label: "1h")]
}


extension ChartColumn {
    static var parts7 : [ChartColumn] = [ChartColumn(label: "Mon", percent: 1.0), ChartColumn(label: "Tue", percent: 0.70), ChartColumn(label: "Wed", percent: 0.6), ChartColumn(label: "Thu", percent: 0.19), ChartColumn(label: "Fri", percent: 0.30), ChartColumn(label: "Sat", percent: 1.0), ChartColumn(label: "Sun", percent: 0.45)]
    
    static var parts6 : [ChartColumn] = [ChartColumn(label: "Mon", percent: 1.0), ChartColumn(label: "Tue", percent: 0.70), ChartColumn(label: "Wed", percent: 0.6), ChartColumn(label: "Thu", percent: 0.19), ChartColumn(label: "Fri", percent: 0.30), ChartColumn(label: "Sat", percent: 1.0)]
    
}

extension ChartColorColumn {
    static var part3 : [ChartColorColumn] = [
        ChartColorColumn(label: "Mon", segments: [ColorSegment(percent: 0.3, type: .Red), ColorSegment(percent: 0.2, type: .White)]),
        ChartColorColumn(label: "Tue", segments: [ColorSegment(percent: 0.3, type: .Red), ColorSegment(percent: 0.2, type: .Yellow)]),
        ChartColorColumn(label: "Wed", segments: [ColorSegment(percent: 0.3, type: .Red), ColorSegment(percent: 0.2, type: .White), ColorSegment(percent: 0.2, type: .Yellow)]),
        ChartColorColumn(label: "Thu", segments: [ColorSegment(percent: 0.3, type: .Red), ColorSegment(percent: 0.2, type: .White)]),
        ChartColorColumn(label: "Fri", segments: [ColorSegment(percent: 0.3, type: .Red), ColorSegment(percent: 0.2, type: .White)]),
        ChartColorColumn(label: "Sat", segments: [ColorSegment(percent: 0.3, type: .Red), ColorSegment(percent: 0.2, type: .White)]),
        ChartColorColumn(label: "Sun", segments: [ColorSegment(percent: 0.3, type: .Red), ColorSegment(percent: 0.2, type: .White)]),
    ]
}

extension ColorSegment{
    static var col2 : [ColorSegment] = [ColorSegment(percent: 0.3, type: .Red), ColorSegment(percent: 0.2, type: .Yellow)]
}
