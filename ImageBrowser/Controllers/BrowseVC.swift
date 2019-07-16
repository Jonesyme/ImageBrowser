//
//  BrowseVC.swift
//  ImageBrowser
//
//  Created by Mike Jones on 7/13/19.
//  Copyright © 2019 Mike Jones. All rights reserved.
//

import UIKit

//
// MARK: - BrowseViewController - Browse images via a CollectionView
//
class BrowseVC: UIViewController {

    // MARK: outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: internal/private members
    internal var photoService: PhotoService?            // service used to fetch/cache remote images
    internal weak var networkTask: URLSessionDataTask?  // handle to URLSession task
    private var photoList:[Photo] = []                  // list of fetched photos
    private let refreshCtrl = UIRefreshControl()        // pull-down to refresh CollectionView
    
    // MARK: view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // pull-down to refresh control
        refreshCtrl.addTarget(self, action: #selector(pullDownToRefreshAction), for: .valueChanged)
        collectionView.addSubview(refreshCtrl)
        photoService = PhotoService(WSSession())
        fetchPhotoList(photoService!)
    }
    
    // MARK: private functions
    @objc private func pullDownToRefreshAction() {
        photoList = []
        collectionView.reloadData()
        photoService!.clearCache()
        fetchPhotoList(photoService!)
    }
    
    internal func fetchPhotoList(_ service: PhotoService) {
        networkTask = service.webSession.downloadJSON(TCEndpoint.photos, responseType: [Photo].self) { [weak self] result in
            switch result {
            case .error(let error):
                print(error)
            case .success(let response):
                self?.photoList = []
                self?.photoList.append(contentsOf: response)
                self?.refreshCtrl.endRefreshing()
                self?.collectionView.reloadData()
            }
        }
    }
}

// MARK: - UICollectionView Delegates
extension BrowseVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        let photoStore = photoList[indexPath.row]
        cell.fetchThumbnailPhoto(photoStore, photoService: photoService!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let detailView = AppDelegate.mainStoryboard.instantiateViewController(withIdentifier: "detailVC") as? DetailVC {
            detailView.photoService = photoService
            detailView.photoStore = photoList[indexPath.row]
            self.navigationController?.pushViewController(detailView, animated: true)
        }
    }

}

