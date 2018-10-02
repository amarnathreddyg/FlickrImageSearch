//
//  FlickrImagesViewController+SearchBar
//  FlickrImageSearch
//
//  Created by Amarnath Gopireddy on 24/09/2018.
//  Copyright © 2018 Amarnath Gopireddy. All rights reserved.
//

import UIKit

extension FlickrImagesViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let query = searchBar.text {
            self.viewModel.query = query;
            self.imagesCollectionView.reloadData()
        }
    }
    
}
