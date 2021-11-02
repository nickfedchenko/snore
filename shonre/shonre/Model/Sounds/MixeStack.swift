//
//  MixeStack.swift
//  whitesound
//
//  Created by Александр Шендрик on 09.09.2021.
//

import Foundation
import Combine

class MixeStack: ObservableObject {
    @Published var mixes : [Mixe]
    @Published var mixesShow : [[Mixe?]] = [[Mixe?]]()
    @Published var type : MixeType = .All
    @Published var playHomeMixe : Mixe?
    @Published var realPlaying : Bool = false
    @Published var popularMixes : [Mixe] = [Mixe]()
    @Published var popularMixesLines : [PopularMixesLine] = [PopularMixesLine]()
    
    @Published var publicMixes : [Mixe] = [Mixe]()
    @Published var publicMixesLines : [PopularMixesLine] = [PopularMixesLine]()
    
    var cancellables = Set<AnyCancellable>()
    var CDHelper : WhiteSoundCDH
    
    init(mixes : [Mixe], CDHelper : WhiteSoundCDH) {
        self.mixes = mixes
        self.CDHelper = CDHelper
        
        $type.sink(receiveValue: {newType in
            self.resetMixes(type: newType)
        }).store(in: &cancellables)
        
        $mixes.debounce(for: 0.0, scheduler: RunLoop.main).sink(receiveValue: {_ in
            self.resetMixes(type: self.type)
        }).store(in: &cancellables)
        
        loadHomeMixeImage()
    }
    
    func updateMixe(_ mixe : Mixe) {
        var isNewMixe = mixes.first(where: {$0.id == mixe.id})
        
        if isNewMixe != nil {
            isNewMixe! = mixe
        } else {
            mixes.append(mixe)
        }
        
    }
    
    func resetMixes(type : MixeType){
        var selectedMixes = self.mixes
        if type != .All {
            selectedMixes = self.mixes.filter({$0.type == type})
        }
        
        var rowsCount : Int = selectedMixes.count / 3
        if selectedMixes.count % 3 > 0 {
            rowsCount += 1
        }
        
        self.mixesShow = [[Mixe?]]()
        for i in 0...rowsCount {
            var newMixeRow = [Mixe?]()
            for j in 0...2 {
                let index = 3 * i + j
                if index < selectedMixes.count {
                    newMixeRow.append(selectedMixes[index])
                } else {
                    newMixeRow.append(nil)
                }
            }
            self.mixesShow.append(newMixeRow)
        }
    }
    
    func loadHomeMixeImage() {
        
        let toLoadImages : [Mixe] = self.mixes.filter({$0.type == .Home}).compactMap({if $0.imageLink != nil && $0.imageFileName == nil {return $0} else {return nil}})
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        for mixe in toLoadImages {
            let operation = DownloadOperation(session: URLSession.shared, downloadTaskURL: URL(string: mixe.imageLink!)!, completionHandler: { (imageTempFileUrl, response, error) in
                let fileName = String(mixe.imageLink!.split(separator: "/").last ?? "nil.jpg")
                
                let fileNameFull = documentDirectory.appendingPathComponent(fileName)
                if let imageTempFileUrl = imageTempFileUrl {
                    do {
                        // Сохранение загруженой картинки
                        let imageData = try Data(contentsOf: imageTempFileUrl)
                        try imageData.write(to: fileNameFull)
                        mixe.imageFileName = fileName
                        mixe.uiImage = mixe.getImage()
                        self.CDHelper.saveMixe(mixe)
                        
                        print("Save Image \(fileName)")
                    } catch {
                        print("Error \(mixe.imageFileName)")
                    }
                }
            })
            queue.addOperation(operation)
        }
    }
    
    func loadInside(mixes : [Mixe]) {
        self.mixes.append(contentsOf: mixes.shuffled())
        loadHomeMixeImage()
        CDHelper.saveMixes(self.mixes)
    }
    
    func loadPopular(mixes : [Mixe]) {
        self.popularMixes = mixes
        
        let rows = self.popularMixes.count / 2 + self.popularMixes.count % 2
        for i in 0...rows {
            let newLine = PopularMixesLine(mixes: [Mixe]())
            if i * 2 < self.popularMixes.count {
                newLine.mixes.append(self.popularMixes[i * 2])
            }
            
            if i * 2 + 1 < self.popularMixes.count {
                newLine.mixes.append(self.popularMixes[i * 2 + 1])
            }
            
            self.popularMixesLines.append(newLine)
        }
    }
    
    func loadPublic(mixes : [Mixe], likeId : [String]) {
        self.publicMixes = mixes
        
        for mixe in self.publicMixes {
            if likeId.contains(mixe.id.uuidString) {
                mixe.liked = true
            }
        }
        
        let rows = self.publicMixes.count / 2 + self.publicMixes.count % 2
        for i in 0...rows {
            let newLine = PopularMixesLine(mixes: [Mixe]())
            if i * 2 < self.publicMixes.count {
                newLine.mixes.append(self.publicMixes[i * 2])
            }
            
            if i * 2 + 1 < self.publicMixes.count {
                newLine.mixes.append(self.publicMixes[i * 2 + 1])
            }
            
            self.publicMixesLines.append(newLine)
        }
    }
    
}


class PopularMixesLine : Identifiable {
    var mixes : [Mixe]
    var id = UUID()
    
    init(mixes : [Mixe]){
        self.mixes = mixes
    }
}
