//
//  DetailVC.swift
//  ImageBrowser
//
//  Created by Mike Jones on 7/13/19.
//  Copyright © 2019 Mike Jones. All rights reserved.
//

import UIKit

//
// MARK: - DetailViewController - Display the full-size image when a BrowseVC thumbnail is tapped
//
class DetailVC: UIViewController {
    
    // MARK: nib outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    // MARK: public members
    public weak var photoStore: Photo?               // photo record to display
    public weak var photoService: PhotoService?      // service to download remote image
    
    // MARK: private members
    private weak var lastNetworkTask: URLSessionDataTask? // handle to any previous download potentially still in progress
    
    // MARK: view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = nil
        fetchFullSizeImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        cancelAnyPriorNetworkTask()
        super.viewWillDisappear(animated)
    }
    
    // MARK: private functions
    internal func fetchFullSizeImage() {
        showActivitySpinner()
        guard let service = photoService, let photo = photoStore else {
            return
        }
        // fetch full-size image from cache or network
        lastNetworkTask = service.fetchFullSize(photo, callback: { [weak self] result in
            switch result {
            case .error(let error):
                print(error.localizedDescription)
            case .success(let image):
                self?.imageView.image = image
            }
            self?.hideActivitySpinner()
        })
    }

    private func cancelAnyPriorNetworkTask() {
        // cancel any image download in progress
        if let task = lastNetworkTask, task.state == URLSessionTask.State.running {
            task.cancel()
        }
    }
    
    private func showActivitySpinner() {
        activitySpinner.isHidden = false
        activitySpinner.startAnimating()
    }
    
    private func hideActivitySpinner() {
        activitySpinner.stopAnimating()
        activitySpinner.isHidden = true
    }
}
