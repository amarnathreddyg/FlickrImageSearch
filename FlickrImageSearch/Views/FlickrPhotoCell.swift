//
//  FlickrPhotoCell.swift
//  FlickrImageSearch
//
//  Created by Amarnath Gopireddy on 25/09/2018.
//  Copyright © 2018 Amarnath Gopireddy. All rights reserved.
//

import UIKit

class FlickrPhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!

    static var cellIdentifier: String {
        return "FlickrPhotoCellIdentifier"
    }
}
