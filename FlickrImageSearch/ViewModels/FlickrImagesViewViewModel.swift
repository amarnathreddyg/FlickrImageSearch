//
//  FlickrImagesViewViewModel.swift
//  FlickrImageSearch
//
//  Created by Amarnath Gopireddy on 26/09/2018.
//  Copyright © 2018 Amarnath Gopireddy. All rights reserved.
//

import Foundation

class FlickrImagesViewViewModel {
    var numberOfPhotos: Int { return photos.count }
    var hasPhotos: Bool { return numberOfPhotos > 0 }
    var queryingDidChange: ((Bool) -> ())?
    var didUpdatePhotos: (([FlickrPhoto]) -> ())?

    var webService = FlickrWebService()

    private var querying: Bool = false {
        didSet {
            queryingDidChange?(querying)
        }
    }
    
    private var photos: [FlickrPhoto] = [] {
        didSet {
            didUpdatePhotos?(photos)
        }
    }

    var query: String = "" {
        didSet {
            FlickrImageDownloadManager.shared.cancelAll()
            searchForPhotos(searchTerm: query)
            photos.removeAll()
        }
    }
    
    
    func photo(at index: Int) -> FlickrPhoto? {
        guard index < photos.count else { return nil }
        return photos[index]
    }
    
    func viewModelForPhoto(at index: Int) -> FlickrPhotoViewModel? {
        if photos.count > 0 {
            let photo = photos[index]
            return FlickrPhotoViewModel(flickrPhoto: photo)
        }
        return nil
    }
    
    // MARK: -
    func searchForPhotos(searchTerm: String?) {
        guard let searchTerm = searchTerm, !searchTerm.isEmpty else {
            photos = []
            return
        }
        
        querying = true
        webService.searchFlickrForTerm(searchTerm) {[weak self] (results, error) in
            guard let photos = results?.searchResults else { return }
            
            self?.querying = false
            
            if let error = error {
                print("Unable to download photos (\(error))")
            }
            else {
                self?.photos = photos
            }
        }
    }
}
