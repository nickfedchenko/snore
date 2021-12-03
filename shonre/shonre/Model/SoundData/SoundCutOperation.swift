//
//  SoundCutOperation.swift
//  shonre
//
//  Created by Александр Шендрик on 03.12.2021.
//

import Foundation
import AVKit

class SoundCutOperation : Operation {
    
    private var task : AVAssetExportSession
    
    enum OperationState : Int {
        case ready
        case executing
        case finished
    }
    
    private var state : OperationState = .ready {
        willSet {
            self.willChangeValue(forKey: "isExecuting")
            self.willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            self.didChangeValue(forKey: "isExecuting")
            self.didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isReady: Bool { return state == .ready }
    override var isExecuting: Bool { return state == .executing }
    override var isFinished: Bool { return state == .finished }
    
    init(task : AVAssetExportSession) {
        self.task = task
    }
    
    
    override func start() {
      if(self.isCancelled) {
          state = .finished
          return
      }
      
      state = .executing
      self.task.exportAsynchronously(completionHandler: {
          switch self.task.status {
              case AVAssetExportSession.Status.failed:
                self.state = .finished
                print("Export failed.")
              default:
                self.state = .finished
                print("Export complete.")
          }
      })
  }
    
    override func cancel() {
        super.cancel()
        self.state = .finished
    }
    
}
