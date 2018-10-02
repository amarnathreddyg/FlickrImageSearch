//
//  FlickrWebService.swift
//  FlickrImageSearch
//
//  Created by Amarnath Gopireddy on 29/09/2018.
//  Copyright © 2018 Amarnath Gopireddy. All rights reserved.
//

import Foundation

let apiKey = "3e7cc266ae2b0e0d78e279ce8e361736"

class FlickrWebService {
    
    func searchFlickrForTerm(_ searchTerm: String,completion : @escaping (_ results: FlickrSearchResults?,_ error : NSError?) -> Void){
        
        let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown Error"])
        
        guard let searchURL = flickrURLForSearchTerm(searchTerm) else {
            completion(nil, APIError)
            return
        }
        
        let searchRequest = URLRequest(url: searchURL)
        URLSession.shared.dataTask(with: searchRequest, completionHandler: { (data, response, error) in
            
            if let error_ = error {
                completion(nil, NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:error_.localizedDescription]))
                return
            }
            
            guard let response_ = response as? HTTPURLResponse,
                response_.statusCode == 200, let data = data else {
                    completion(nil, APIError)
                    return
            }
            
            do {
                guard let results = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String: AnyObject] else {
                    completion(nil, APIError)
                    return
                }
                print(results)
                
                guard let photosContainer = results["photos"] as? [String: AnyObject], let photosReceived = photosContainer["photo"] as? [[String: AnyObject]] else {
                    
                     completion(nil, APIError)
                    return
                }
                var flickrPhotos = [FlickrPhoto]()
                for photoObject in photosReceived {
                    guard let photoID = photoObject["id"] as? String,
                        let farm = photoObject["farm"] as? Int ,
                        let server = photoObject["server"] as? String ,
                        let secret = photoObject["secret"] as? String else {
                            break
                    }
                    let flickrPhoto = FlickrPhoto(photoID: photoID, farm: farm, server: server, secret: secret)
                    flickrPhotos.append(flickrPhoto)
                }
                completion(FlickrSearchResults(searchResults: flickrPhotos) ,nil)
                
            } catch _ {
                completion(nil, APIError)
                return
            }
        }) .resume()
    }
    
    fileprivate func flickrURLForSearchTerm(_ searchTerm:String) -> URL? {
        
        guard let escapedTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
            return nil
        }
        let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&format=json&nojsoncallback=1&safe_search=1&text=\(escapedTerm)"
        
        guard let url = URL(string:URLString) else {
            return nil
        }
        
        return url
    }
}


