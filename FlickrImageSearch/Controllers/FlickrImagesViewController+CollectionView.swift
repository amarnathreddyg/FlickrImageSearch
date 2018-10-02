//
//  FlickrImagesViewController+CollectionView
//  FlickrImageSearch
//
//  Created by Amarnath Gopireddy on 24/09/2018.
//  Copyright © 2018 Amarnath Gopireddy. All rights reserved.
//

import UIKit

extension FlickrImagesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfPhotos;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlickrPhotoCell.cellIdentifier, for: indexPath) as! FlickrPhotoCell
        return cell

    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as! FlickrPhotoCell).imageView.image = #imageLiteral(resourceName: "placeholder")
        if let imageViewModel = self.viewModel.viewModelForPhoto(at: indexPath.row) {
            FlickrImageDownloadManager.shared.downloadImage(imageViewModel, indexPath: indexPath) { [weak self](image, url, indexPathh, error) in
                if let indexPathNew = indexPathh {
                    DispatchQueue.main.async {
                        let path = IndexPath(row: indexPathNew.row, section: 0)
                        if let cell = self?.imagesCollectionView.cellForItem(at: path) as? FlickrPhotoCell {
                            UIView.transition(with: cell.imageView,
                                              duration: 0.5,
                                              options: .curveEaseOut,
                                              animations: { cell.imageView.image = image },
                                              completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Reduce the priority of the network operation in case the user scrolls and an image is no longer visible
        if let flickrPhotoViewModel = self.viewModel.viewModelForPhoto(at: indexPath.row) {
            FlickrImageDownloadManager.shared.slowDownImageDownloadTaskfor(flickrPhotoViewModel)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    // return the spacing between the cells, headers, and footers. Used a constant for that
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // controls the spacing between each line in the layout. this should be matched the padding at the left and right
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

