//
//  CalcSiundStaticics.swift
//  shonre
//
//  Created by Александр Шендрик on 11.10.2021.
//

import Foundation
import SwiftUI

class CalcSoundStaticics {
    init(){
        
    }
    
    static func getThisWeekSounds(_ sounds : [Sound]) -> [Sound] {
        let today = Date()
        let calendar = Calendar.current
        
        let currentWeek = calendar.component(.weekOfYear, from: today)
        let weekday = calendar.component(.weekday, from: today)
        
        return sounds.compactMap({ if calendar.component(.weekOfYear, from: $0.started) ==  currentWeek {return $0 } else { return nil} })
    }
    
    
    static func getSleepDuration(_ sounds : [Sound]) -> [ChartColumn] {
        let calendar = Calendar.current
        let thisWeekSounds : [Sound] = getThisWeekSounds(sounds)
        
        let wd = calendar.component(.weekday, from: Date())
        print(wd)
        
        var out = [ChartColumn]()
        let maxLen : Double = 3600 * 12
        
        for weekDay in 1...7 {
            let dayKey : LocalizedStringKey = getDayKey(weekDay)

            let soundsForDay : [Sound] = thisWeekSounds.compactMap({ if calendar.component(.weekday, from: $0.started) == weekDay {return $0} else {return nil} })
            
            print("dayKey")
            print(dayKey)
            print(soundsForDay)
            
            var dayLen : Double = 0.0
            for sound in soundsForDay {
                dayLen += sound.length
            }
            
            print(dayLen)
            print(maxLen)
            let percent : Double = dayLen / maxLen
            print(percent)
            let newChar = ChartColumn(label: dayKey, percent: percent < 1 ? percent : 1.0)
            out.append(newChar)
        }
        print("getSleepDuration")
        print(out)
        return out
    }
    
    static func getSleepTime(_ sounds : [Sound]) -> [ChartColumn] {
        let calendar = Calendar.current
        let thisWeekSounds : [Sound] = getThisWeekSounds(sounds)
        
        var out = [ChartColumn]()
        for weekDay in 1...7 {
            let dayKey : LocalizedStringKey = getDayKey(weekDay)
            
            var soundsForDay : [Sound] = thisWeekSounds.compactMap({ if calendar.component(.weekday, from: $0.started) == weekDay {return $0} else {return nil} })
            soundsForDay.sort(by: {$0.started > $1.started})
            
            var hour = !soundsForDay.isEmpty ? calendar.component(.hour, from: soundsForDay[0].started) : 0
            hour = hour > 19 ? hour : 19
            
            let percent : Double = Double(hour - 19) / 7
            let newChar = ChartColumn(label: dayKey, percent: percent < 1 ? percent : 1.0)
            out.append(newChar)
        }
        
        return out
    }
    
    static func getSnoringDuration(_ sounds : [Sound]) -> [ChartColumn] {
        let calendar = Calendar.current
        let thisWeekSounds : [Sound] = getThisWeekSounds(sounds)
        
        var out = [ChartColumn]()
        let maxLen : Double = 3600 * 12
        
        for weekDay in 1...7 {
            let dayKey : LocalizedStringKey = getDayKey(weekDay)
            let soundsForDay : [Sound] = thisWeekSounds.compactMap({ if calendar.component(.weekday, from: $0.started) == weekDay {return $0} else {return nil} })
            
            var allSnoring : Double = 0.0
            
            for sound in soundsForDay {
                allSnoring += sound.timeSnoringPercentRed
            }
            
            let percent : Double = allSnoring / maxLen
            let newChar = ChartColumn(label: dayKey, percent: percent < 1 ? percent : 1.0)
            out.append(newChar)
        }
        
        return out
    }
    
    static func getSnoreScore(_ sounds : [Sound]) -> [ChartColorColumn] {
        let calendar = Calendar.current
        let thisWeekSounds : [Sound] = getThisWeekSounds(sounds)
        
        var out = [ChartColorColumn]()
        let maxLen : Double = 3600 * 12
        
        for weekDay in 1...7 {
            let dayKey : LocalizedStringKey = getDayKey(weekDay)
            
            var soundsForDay : [Sound] = thisWeekSounds.compactMap({ if calendar.component(.weekday, from: $0.started) == weekDay {return $0} else {return nil} })
            soundsForDay.sort(by: {$0.started < $1.started})
            var allWaves : [SingleWave] = [SingleWave]()
            var allLength : Double = 0.0
            
            for sound in soundsForDay {
                allWaves.append(contentsOf: sound.waves)
                allLength += sound.length
            }
            let coiff : Double = (allLength / maxLen) / Double(allWaves.count)
            var segments : [ColorSegment] = [ColorSegment]()
            
            
            let step = 20
            let lenght : Int = allWaves.count / step
            
            for i in 0..<lenght{
                var whiteCount = 0
                var yellowCount = 0
                var redCount = 0
                
                for j in 0..<step {
                    let index = i * step + j < allWaves.count ? i * step + j : allWaves.count - 1
                    switch allWaves[index].color{
                    case .White:
                        whiteCount += 1
                    case .Yellow:
                        yellowCount += 1
                    case .Red:
                        redCount += 1
                    }
                }
                
                if whiteCount > yellowCount {
                    if whiteCount > redCount {
                        segments.append(ColorSegment(percent: Double(step) * coiff, type: ColorType.White))
                    } else {
                        segments.append(ColorSegment(percent: Double(step) * coiff, type: ColorType.Red))
                    }
                } else {
                    if yellowCount > redCount {
                        segments.append(ColorSegment(percent: Double(step) * coiff, type: ColorType.Yellow))
                    } else {
                        segments.append(ColorSegment(percent: Double(step) * coiff, type: ColorType.Red))
                    }
                }
            }
            
            let newChar = ChartColorColumn(label: dayKey, segments: segments)
            out.append(newChar)
        }

        return out
    }
    
    static func getAverageSleepTime(_ sounds : [Sound]) -> String {
        let thisWeekSounds : [Sound] = getThisWeekSounds(sounds)
        var count : Double = 0.0
        
        for sound in thisWeekSounds {
            count += sound.length
        }
        count = count / 7
        
        let h : Int = Int(count) / 3600
        let m : Int = Int(count) % 60
        let out : String = "This day average is \(h) hours \(m) min"
        
        return out
    }
    
    
    static func getDayKey(_ day : Int) -> LocalizedStringKey {
        switch day {
        case 2:
            return "Mon"
        case 3:
            return "Tue"
        case 4:
            return "Wen"
        case 5:
            return "Thu"
        case 6:
            return "Fri"
        case 7:
            return "Sat"
        case 1:
            return "Sun"
        default:
            return "Mon"
        }
    }
}
