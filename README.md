# FlickrImageSearch
Downloads images seamlessly from flickr and renders on a UICollectionView

Following are the key highlights of this project :

Used MVVM architecture

Used Operation and OperationQueue to download images asynchronously

Prioritise the downloading tasks based on the visibility of cells

FlickrImageDownloadManager class will create a singleton instance and have NSCache instance to cache the images that have been downloaded
