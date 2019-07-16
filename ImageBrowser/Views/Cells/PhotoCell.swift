//
//  PhotoCell.swift
//  ImageBrowser
//
//  Created by Mike Jones on 7/13/19.
//  Copyright © 2019 Mike Jones. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    // MARK: outlets
    @IBOutlet weak var shadowView: UIView! { // superfluous view needed to add shadow (bc child view clips to rounded corners)
        didSet(param){
            shadowView.backgroundColor = UIColor.clear
            shadowView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
            shadowView.layer.shadowOpacity = 0.95
            shadowView.layer.shadowRadius = 7.0
        }
    }
    @IBOutlet weak var imageView: UIImageView! {
        didSet(param){
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 4.0
            imageView.layer.borderColor = UIColor.black.cgColor
            imageView.layer.borderWidth = 1.0
            imageView.layer.masksToBounds = true
        }
    }

    // MARK: class members
    public class var reuseIdentifier: String { return "photoCell" }
    public class var cellHeight: CGFloat { return 150.0 }

    // MARK: private members
    private var lastNetworkTask: URLSessionDataTask?  // handle to any prior download that may still be in progress
    public var image: UIImage? {
        set(newImage) {
            imageView.image = newImage
        }
        get {
            return imageView.image
        }
    }
    
    // MARK: view lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        showPlaceholderImage()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cancelAnyPriorNetworkTask()
        showPlaceholderImage()
    }
    
    // MARK: public functions
    public func fetchThumbnailPhoto(_ photoStore: Photo, photoService: PhotoService) {
        lastNetworkTask = photoService.fetchThumb(photoStore, callback: { [weak self] result in
            switch result {
            case .error(let error):
                print(error.localizedDescription)
            case .success(let image):
                self?.imageView.image = image
            }
        })
    }
    
    // MARK: private functions
    private func cancelAnyPriorNetworkTask() {
        // cancel any thumbnail image download in progress
        if let task = lastNetworkTask, task.state == URLSessionTask.State.running {
            task.cancel()
        }
    }
    
    private func showPlaceholderImage() {
        image = UIImage(named: "placeholder")
    }
}
