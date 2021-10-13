//
//  Sound.swift
//  shonre
//
//  Created by Александр Шендрик on 05.10.2021.
//

import Foundation

class Sound : Identifiable, ObservableObject {
    var id : UUID
    @Published var waves : [SingleWave]
    var length : Double
    var timeInBed : Double
    var started : Date
    var stoped : Date
    var fileName : String
    var inDayCound : Int
    
    var timeNoSnoring : Double
    var timeSnoringRed : Double
    var timeSnoringYellow : Double
    
    var timeNoSnoringPercentWhite : Double
    var timeSnoringPercentRed : Double
    var timeSnoringPercentYellow : Double
    
    init(id : UUID, waves : [SingleWave], timeInBed : Double, started : Date, stoped : Date, fileName : String, inDayCound : Int){
        self.id = id
        self.waves = waves
        self.length = stoped.timeIntervalSinceReferenceDate - started.timeIntervalSinceReferenceDate
        self.timeInBed = timeInBed
        self.started = started
        self.stoped = stoped
        self.fileName = fileName
        self.inDayCound = inDayCound
        
        self.timeNoSnoring = 0
        self.timeSnoringRed = 0
        self.timeSnoringYellow = 0
        
        self.timeNoSnoringPercentWhite = 0.4
        self.timeSnoringPercentRed = 0.4
        self.timeSnoringPercentYellow = 0.2
        
        var countNoSnoring : Double = 0
        var countSnoringPercentRed : Double = 0
        var countSnoringPercentYellow : Double = 0
        
        for wave in waves {
            switch wave.color{
            case .White:
                countNoSnoring += 1
            case .Yellow:
                countSnoringPercentRed += 1
            case .Red:
                countSnoringPercentYellow += 1
            }
        }
        
        self.timeNoSnoringPercentWhite = countNoSnoring / Double(waves.count)
        self.timeSnoringPercentYellow = countSnoringPercentYellow / Double(waves.count)
        self.timeSnoringPercentRed = countSnoringPercentRed / Double(waves.count)
    }
    
    init(id : UUID, samples : [Float], timeInBed : Double, started : Date, stoped : Date, fileName : String, inDayCound : Int){
        self.id = id
        self.waves = [SingleWave]()
        self.length = stoped.timeIntervalSinceReferenceDate - started.timeIntervalSinceReferenceDate
        self.timeInBed = timeInBed
        self.started = started
        self.stoped = stoped
        self.fileName = fileName
        self.inDayCound = inDayCound
        
        self.timeNoSnoring = 0
        self.timeSnoringRed = 0
        self.timeSnoringYellow = 0
        
        self.timeNoSnoringPercentWhite = 0.4
        self.timeSnoringPercentYellow = 0.2
        self.timeSnoringPercentRed = 0.4
        
        for i in 0..<samples.count{
            self.waves.append(SingleWave(id: UUID(), volume: 1.0 - samples[i], number: i, color: ColorType(volume: 1.0 - samples[i])))
        }
        
        var countNoSnoring : Double = 0
        var countSnoringPercentRed : Double = 0
        var countSnoringPercentYellow : Double = 0
        
        for wave in waves {
            switch wave.color{
            case .White:
                countNoSnoring += 1
            case .Yellow:
                countSnoringPercentRed += 1
            case .Red:
                countSnoringPercentYellow += 1
            }
        }
        
        self.timeNoSnoringPercentWhite = countNoSnoring / Double(waves.count)
        self.timeSnoringPercentYellow = countSnoringPercentYellow / Double(waves.count)
        self.timeSnoringPercentRed = countSnoringPercentRed / Double(waves.count)
    }
    
    func chartParts() -> [Double] {
        var out : [Double] = [Double]()
        
        if timeNoSnoringPercentWhite > 0 {
            out.append(timeNoSnoringPercentWhite)
        }
        
        
        if timeSnoringPercentYellow > 0 {
            out.append(timeSnoringPercentYellow)
        }
        
        if timeSnoringPercentRed > 0 {
            out.append(timeSnoringPercentRed)
        }
        
        return out
    }
    
    func addSamples(samples : [Float], level : Double){
        var addWawes : [SingleWave] = [SingleWave]()
        for i in 0..<samples.count{
            addWawes.append(SingleWave(id: UUID(), volume: 1.0 - samples[i], number: i, color: ColorType(volume: 1.0 - samples[i], level: level)))
        }
        self.waves = addWawes
        
        var countNoSnoring : Double = 0
        var countSnoringPercentRed : Double = 0
        var countSnoringPercentYellow : Double = 0
        
        for wave in waves {
            switch wave.color{
            case .White:
                countNoSnoring += 1
            case .Yellow:
                countSnoringPercentRed += 1
            case .Red:
                countSnoringPercentYellow += 1
            }
        }
        
        self.timeNoSnoringPercentWhite = countNoSnoring / Double(waves.count)
        self.timeSnoringPercentYellow = countSnoringPercentYellow / Double(waves.count)
        self.timeSnoringPercentRed = countSnoringPercentRed / Double(waves.count)
    }
    
    func recolor(level : Double) {
        var newWaves : [SingleWave] = [SingleWave]()
        for wave in waves {
            newWaves.append(SingleWave(id: UUID(), volume: wave.volume, number: waves.firstIndex(where: {$0.id == wave.id})!, color: ColorType(volume: wave.volume, level: level)))
        }
        self.waves = newWaves
    }
    
    func getGraphWaves(count : Int) -> [SingleWave] {
        if count == self.waves.count {
            return waves
        }
        
        var out = [SingleWave]()
        let dif = self.waves.count / count
        if self.waves.count > 0 {
            for i in 0..<count {
                let pre : Int = Int( i * dif)
                let index : Int = pre < self.waves.count ? pre : self.waves.count - 1
                out.append(self.waves[index])
            }
        }
        return out
    }
    
    func getDateSting() -> String {
        let formatter = DateFormatter()
        
        let langStr = Locale.current.languageCode
        if langStr == "ru" {
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.dateFormat = "EEEE, dd.MM.yyyy, HH:mm"
        }
        
        if langStr == "en" {
            formatter.locale = Locale(identifier: "en")
            formatter.dateFormat = "EEEE, dd.MM.yyyy, HH:mm"
        }
        
        return formatter.string(from: self.started)
    }
    
    // Тексты для меню
    func getStartedStopedText() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        return formatter.string(from: self.started) + " : " + formatter.string(from: self.stoped)
    }
    
    func getTimeInBed() -> String{
        let h : Int = Int(length) / 3600
        let m : Int = Int(length) / 60
        
        return "\(h) h \(m) m"
    }
    
    func getTimeSnoring() -> String{
        let snoringPersent : Double = timeSnoringPercentRed + timeSnoringPercentYellow
        let snorintTime : Double = length * snoringPersent
        
        guard !(snorintTime.isNaN || snorintTime.isInfinite) else {
            return "No snoring"
        }
        let h : Int = Int(snorintTime) / 3600
        let m : Int = Int(snorintTime) / 60
        
        return "\(h) h \(m) m - \(Int(snoringPersent * 100)) %"
    }
    
    func getBeggingText() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let startedStr : String = formatter.string(from: self.started)
        
        let h : Int = Int(self.length) / 3600
        let m : Int = Int(self.length) / 60
        let s : Int = Int(self.length) % 60
        
        let mStr : String = m > 9 ? "\(m)" : "0\(m)"
        let sStr : String = s > 9 ? "\(s)" : "0\(s)"
        
        let clocks : String = h > 0 ? "\(h) hours \(mStr) min" : "\(mStr) min \(sStr) sec"
        let begin = "begin at "
        
        return "\(begin) \(startedStr) (\(clocks))"
    }
    
    
}


extension Sound {
    static private var floats : [Float] = [0.99631536, 0.88143545, 0.8690525, 0.90042555, 0.89091307, 0.9181897, 0.90042824, 0.9216587, 0.8653955, 0.8346866, 0.9202248, 0.88684076, 0.9029135, 0.8927926, 0.9276208, 0.83541024, 0.90396637, 0.9164989, 0.89201266, 0.88179106, 0.8197699, 0.8900345, 0.9271752, 0.9015595, 0.920471, 0.88736254, 0.8665565, 0.8510159, 0.9013519, 0.8974382, 0.8225154, 0.80960155, 0.85962987, 0.8551391, 0.8911549, 0.8987075, 0.91848785, 0.91331923, 0.88964784, 0.84326535, 0.8045854, 0.916341, 0.92860913, 0.90928614, 0.9302227, 0.92358965, 0.89631915, 0.8491593, 0.7968453, 0.9173376, 0.900619, 0.89133376, 0.8948654, 0.8322924, 0.92450196, 0.91265494, 0.8896222, 0.86081284, 0.86829156, 0.8913391, 0.8880747, 0.90776354, 0.8695343, 0.87320024, 0.92953086, 0.838195, 0.857576, 0.91787916, 0.75138575, 0.88541585, 0.898067, 0.9306363, 0.91902304, 0.8389896, 0.8715426, 0.89709395, 0.907642, 0.85675347, 0.8420348, 0.73695165, 0.93613553, 0.93468016, 0.9366257, 0.8980424, 0.8964634, 0.8684562, 0.66798866, 0.91594446, 0.95174736, 0.91015655, 0.94065183, 0.92026275, 0.87230134, 0.7610337, 0.87457734, 0.88539785, 0.8882004, 0.8762126, 0.9377201, 0.80177057, 0.84960854, 0.93595934, 0.84425026, 0.936606, 0.87830865, 0.89615655, 0.91328794, 0.9080092, 0.88472944, 0.78950846, 0.8246434, 0.8988554, 0.90711766, 0.8827296, 0.89345396, 0.86016536, 0.82851183, 0.9005243, 0.92860514, 0.94474864, 0.75429815, 0.9105445, 0.88745207, 0.87358207, 0.89007705, 0.83859354, 0.8786297, 0.91080934, 0.86784226, 0.88092405, 0.84398115, 0.838828, 0.91178244, 0.848264, 0.88138473, 0.8390765, 0.8495464, 0.850896, 0.81310606, 0.83613527, 0.77825814, 0.8820747, 0.92350096, 0.87226325, 0.90040594, 0.84130484, 0.8671946, 0.8622845, 0.92002463, 0.9167881, 0.8503784, 0.9007009, 0.9319803, 0.91381615, 0.9233342, 0.8225254, 0.82523453, 0.89886695, 0.90082765, 0.93578833, 0.90041876, 0.93329054, 0.91834146, 0.82255477, 0.8502985, 0.9054464, 0.91850495, 0.8440917, 0.8850215, 0.88002896, 0.91301507, 0.858498, 0.832715, 0.88503754, 0.90128326, 0.9085095, 0.9053642, 0.91603494, 0.8299022, 0.88832086, 0.9046554, 0.8798256, 0.91803896, 0.8820022, 0.9171299, 0.91135275, 0.91544586, 0.8726915, 0.87396806, 0.8145298, 0.9123213, 0.9364333, 0.8936384, 0.9014277, 0.8839295, 0.9053699, 0.90971756, 0.8561685, 0.9904829, 1.0001026]
    
    static var data = [Sound(id: UUID(), samples: floats, timeInBed: 30 * 60, started: Date().addingTimeInterval(-3600 * 2.7), stoped: Date(), fileName: "", inDayCound: 1)]
}
