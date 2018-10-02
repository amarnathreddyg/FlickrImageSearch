//
//  FlickrPhoto.swift
//  FlickrImageSearch
//
//  Created by Amarnath Gopireddy on 25/09/2018.
//  Copyright © 2018 Amarnath Gopireddy. All rights reserved.
//

import Foundation

class FlickrPhoto : Equatable {
    let photoID : String
    let farm : Int
    let server : String
    let secret : String
    
    init (photoID:String, farm:Int, server:String, secret:String) {
        self.photoID = photoID
        self.farm = farm
        self.server = server
        self.secret = secret
    }
}

func == (lhs: FlickrPhoto, rhs: FlickrPhoto) -> Bool {
    return lhs.photoID == rhs.photoID
}
