//
//  FlickrImageOperation.swift
//  FlickrImageSearch
//
//  Created by Amarnath Gopireddy on 26/09/2018.
//  Copyright © 2018 Amarnath Gopireddy. All rights reserved.
//

import Foundation
import UIKit

class FlickrImageOperation: Operation {
    
    var completionHandler: ImageDownloadCompletionHandler?
    var imageUrl: URL!
    private var indexPath: IndexPath?
    
    required init (url: URL, indexPath: IndexPath?) {
        self.imageUrl = url
        self.indexPath = indexPath
    }
    
    override func main() {
        guard isCancelled == false else {
            finish(true)
            return
        }
        self.executing(true)
        self.downloadImageFromUrl()
    }
    
    override var isAsynchronous: Bool {
        get {
            return  true
        }
    }
    private var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override var isExecuting: Bool {
        return _executing
    }
    
    private var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isFinished: Bool {
        return _finished
    }
    
    func executing(_ executing: Bool) {
        _executing = executing
    }
    
    func finish(_ finished: Bool) {
        _finished = finished
    }
    
    func downloadImageFromUrl() {
        let newSession = URLSession.shared
        let downloadTask = newSession.downloadTask(with: self.imageUrl) { (location, response, error) in
            if let locationUrl = location, let data = try? Data(contentsOf: locationUrl){
                let image = UIImage(data: data)
                self.completionHandler?(image,self.imageUrl, self.indexPath,error)
            }
            self.finish(true)
            self.executing(false)
        }
        downloadTask.resume()
    }
}

