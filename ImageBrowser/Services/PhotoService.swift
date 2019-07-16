//
//  PhotoService.swift
//  ImageBrowser
//
//  Created by Mike Jones on 7/13/19.
//  Copyright © 2019 Mike Jones. All rights reserved.
//

import Foundation
import UIKit

//
// MARK - Photo Service to manage the fetching and mem caching of photos
//
public enum PhotoServResponse {
    case success(UIImage)
    case error(Error)
}

//
// MARK: - Service for fetching and auto-caching remote images
//
public class PhotoService {

    // MARK: private members
    private var photoCache:[Int:UIImage] = [:]  // full-size photo cache
    private var thumbCache:[Int:UIImage] = [:]  // thumbnail photo cache
    
    // MARK: public members
    public var webSession: WSSessionProtocol    // WebService session for network requests
    
    // MARK: initializer
    required init(_ session: WSSessionProtocol) {
        webSession = session
    }

    // MARK: public functions
    public func clearCache() {
        photoCache = [:]
        thumbCache = [:]
    }
    
    // fetch full-size photo from remote endpoint or local cache if we have it already
    public func fetchFullSize(_ photoStore: Photo, callback: @escaping (PhotoServResponse) -> Void) -> URLSessionDataTask? {
        var task: URLSessionDataTask? = nil
        if let cachedImage = photoCache[photoStore.id] {
            callback(.success(cachedImage)) // return cached image
        } else {
            // no cache, download remote image
            task = webSession.downloadImage(photoStore.url, success: { [weak self] image in
                callback(.success(image))
                self?.photoCache[photoStore.id] = image // cache image for potential later use
            }, failure: { error in
                callback(.error(error))
            })
        }
        return task // so caller can cancel network request
    }
    
    // fetch thumb-size photo from remote endpoint or local cache if we have it already
    public func fetchThumb(_ photoStore: Photo, callback: @escaping (PhotoServResponse) -> Void) -> URLSessionDataTask? {
        var task: URLSessionDataTask? = nil
        if let cachedThumb = thumbCache[photoStore.id] {
            callback(.success(cachedThumb)) // return cached image
        } else {
            // no cache, download remote image
            task = webSession.downloadImage(photoStore.thumbnailUrl, success: { [weak self] image in
                callback(.success(image))
                self?.thumbCache[photoStore.id] = image // cache image for potential later use
            }, failure: { error in
                callback(.error(error))
            })
        }
        return task // so caller can cancel network request
    }
    
    
}
