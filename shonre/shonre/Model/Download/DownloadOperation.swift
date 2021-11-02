//
//
//
//
//  Created by Александр Шендрик on 26.08.2021.
//

import Foundation

class DownloadOperation : Operation {
    
    private var task : URLSessionDownloadTask!
    
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
  
    init(session: URLSession, downloadTaskURL: URL, completionHandler: ((URL?, URLResponse?, Error?) -> Void)?) {
        super.init()
        
        task = session.downloadTask(with: downloadTaskURL, completionHandler: { [weak self] (localURL, response, error) in

            if let completionHandler = completionHandler {
                completionHandler(localURL, response, error)
            }
            self?.state = .finished
        })
    }

    override func start() {
      if(self.isCancelled) {
          state = .finished
          return
      }
      
      state = .executing
      self.task.resume()
  }

  override func cancel() {
      super.cancel()
      self.task.cancel()
  }
}


//let queue = OperationQueue()
//queue.maxConcurrentOperationCount = 1
//
//
//for lesson in lessonsToLoad {
//    let operation = DownloadOperation(session: URLSession.shared, downloadTaskURL: URL(string: lesson.url)!, completionHandler: { (audioTempFileUrl, response, error) in
//        let fileNameFull = documentDirectory.appendingPathComponent(lesson.fileName)
//        if let audioTempFileUrl = audioTempFileUrl {
//            do {
//                // Сохранение загруженого файла
//                let audioData = try Data(contentsOf: audioTempFileUrl)
//                try audioData.write(to: fileNameFull)
//                lesson.loaded = true
//            } catch {
//                print("Error \(lesson.url)")
//            }
//        }
//    })
//    queue.addOperation(operation)
//}
