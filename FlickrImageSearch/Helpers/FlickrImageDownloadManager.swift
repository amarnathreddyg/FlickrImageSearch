//
//  FlickrImageDownloadManager.swift
//  FlickrImageSearch
//
//  Created by Amarnath Gopireddy on 26/09/2018.
//  Copyright © 2018 Amarnath Gopireddy. All rights reserved.
//

import Foundation
import UIKit

typealias ImageDownloadCompletionHandler = (_ image: UIImage?, _ url: URL, _ indexPath: IndexPath?, _ error: Error?) -> Void

class FlickrImageDownloadManager {
    
    private var completionHandler: ImageDownloadCompletionHandler?
    lazy var imageDownloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "com.FlickrImageSearch.FlickrImageSearchQueue"
        return queue
    }()
    
    let imageCache = NSCache<NSString, UIImage>()
    
    static let shared = FlickrImageDownloadManager()
    
    private init () {}
    
    func downloadImage(_ flickrPhoto: FlickrPhotoViewModel, indexPath: IndexPath?, imageView:UIImageView) {
        
        guard let url = flickrPhoto.imageURL else {
            return
        }
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            //check for the cached image for url, if YES then return the cached image
            print("Cached Image for \(url)")
            imageView.image = cachedImage;
        } else {
            /* check if there is a download task that is currently downloading the same image. */
            if let operations = (imageDownloadQueue.operations as? [FlickrImageOperation])?.filter({$0.imageUrl.absoluteString == url.absoluteString && $0.isFinished == false && $0.isExecuting == true }), let operation = operations.first {
                print("Increase the priority for \(url)")
                operation.queuePriority = .veryHigh
            }else {
                /* create a new task to download the image.  */
                print("Create a new task for \(url)")
                let operation = FlickrImageOperation(url: url, indexPath: indexPath)
                if indexPath == nil {
                    operation.queuePriority = .high
                }
                operation.completionHandler = { (image, url, indexPath, error) in
                    if let newImage = image {
                        self.imageCache.setObject(newImage, forKey: url.absoluteString as NSString)
                    }
                    imageView.image = image;
                }
                imageDownloadQueue.addOperation(operation)
            }
        }
    }
    
    func downloadImage(_ flickrPhoto: FlickrPhotoViewModel, indexPath: IndexPath?, handler: @escaping ImageDownloadCompletionHandler) {
        self.completionHandler = handler
        guard let url = flickrPhoto.imageURL else {
            return
        }
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            //check for the cached image for url, if YES then return the cached image
            print("Cached Image for \(url)")
            self.completionHandler?(cachedImage, url, indexPath, nil)
        } else {
            /* check if there is a download task that is currently downloading the same image. */
            if let operations = (imageDownloadQueue.operations as? [FlickrImageOperation])?.filter({$0.imageUrl.absoluteString == url.absoluteString && $0.isFinished == false && $0.isExecuting == true }), let operation = operations.first {
                print("Increase the priority for \(url)")
                operation.queuePriority = .veryHigh
            }else {
                /* create a new task to download the image.  */
                print("Create a new task for \(url)")
                let operation = FlickrImageOperation(url: url, indexPath: indexPath)
                if indexPath == nil {
                    operation.queuePriority = .high
                }
                operation.completionHandler = { (image, url, indexPath, error) in
                    if let newImage = image {
                        self.imageCache.setObject(newImage, forKey: url.absoluteString as NSString)
                    }
                    self.completionHandler?(image, url, indexPath, error)
                }
                imageDownloadQueue.addOperation(operation)
            }
        }
    }
    
    /* function to reduce the priority of the network operation in case the user scrolls and an image is no longer visible. */
    func slowDownImageDownloadTaskfor (_ flickrPhoto: FlickrPhotoViewModel) {
        guard let url = flickrPhoto.imageURL else {
            return
        }
        if let operations = (imageDownloadQueue.operations as? [FlickrImageOperation])?.filter({$0.imageUrl.absoluteString == url.absoluteString && $0.isFinished == false && $0.isExecuting == true }), let operation = operations.first {
            print("Reduce the priority for \(url)")
            operation.queuePriority = .low
        }
    }
    
    func cancelAll() {
        imageDownloadQueue.cancelAllOperations()
    }
    
}
