//
//  FlickrImagesViewController.swift
//  FlickrImageSearch
//
//  Created by Amarnath Gopireddy on 24/09/2018.
//  Copyright © 2018 Amarnath Gopireddy. All rights reserved.
//

import UIKit

class FlickrImagesViewController: UIViewController {

    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noResultsLabel: UILabel!
    
    var itemsPerRow: CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)

    var viewModel: FlickrImagesViewViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = FlickrImagesViewViewModel()
        activityIndicator.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)

        self.viewModel.didUpdatePhotos = { [unowned self] (photos) in
            DispatchQueue.main.async {
                self.imagesCollectionView.reloadData()
                if self.viewModel.numberOfPhotos == 0 {
                    if !self.activityIndicator.isAnimating {
                        self.noResultsLabel.isHidden = false
                    }
                } else {
                    self.noResultsLabel.isHidden = true
                }
            }
        }
        
        self.viewModel.queryingDidChange = { (querying) in
            if querying {
                //show Loading
                DispatchQueue.main.async {
                    self.activityIndicator.startAnimating()
                    self.noResultsLabel.isHidden = true
                }
            }
            else {
                //Hide Loading
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.noResultsLabel.isHidden = false
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

