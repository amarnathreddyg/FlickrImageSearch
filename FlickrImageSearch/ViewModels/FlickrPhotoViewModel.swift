//
//  FlickrPhotoViewModel.swift
//  FlickrImageSearch
//
//  Created by Amarnath Gopireddy on 25/09/2018.
//  Copyright © 2018 Amarnath Gopireddy. All rights reserved.
//

import Foundation

struct FlickrPhotoViewModel {
    
    var flickrPhoto: FlickrPhoto
    
    var farm: String {
        return String(flickrPhoto.farm)
    }
    
    var server: String {
        return flickrPhoto.server
    }
    
    var photoId: String {
        return flickrPhoto.photoID
    }
    
    var secret: String {
        return flickrPhoto.secret
    }
    
    var imageURL: URL? {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret).jpg")
    }
    
}
