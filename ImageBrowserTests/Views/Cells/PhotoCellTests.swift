//
//  PhotoCellTests.swift
//  ImageBrowserTests
//
//  Created by Mike Jones on 7/14/19.
//  Copyright © 2019 Mike Jones. All rights reserved.
//

import XCTest
@testable import ImageBrowser


class PhotoCellTests: XCTestCase {

    var browseVC: BrowseVC!
    var window: UIWindow!
    var wsSessionMock: WSSessionMock?
    var photoService: PhotoService?
    var photoCell: PhotoCell?
    
    override func setUp() {
        wsSessionMock = WSSessionMock()
        photoService = PhotoService(wsSessionMock!)
        
        window = UIWindow()
        browseVC = AppDelegate.mainStoryboard.instantiateViewController(withIdentifier: "browseVC") as? BrowseVC
        browseVC.photoService = PhotoService(WSSessionMock())
        window.addSubview(browseVC.view)
        window.addSubview(browseVC.collectionView)
        browseVC.collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        RunLoop.current.run(until: Date())
    }
    
    func testSetupOK() {
        XCTAssertNotNil(browseVC)
        XCTAssertNotNil(browseVC?.collectionView)
        XCTAssertNotNil(browseVC?.photoService)
    }
    
    func testForProperCollectionViewCells() {
        browseVC.networkTask?.cancel() // cancel any previous fetch invoked by loading view
        let testExpectation = expectation(description: #function)
        let wsSessionMock = WSSessionMock()
        let photoService = PhotoService(wsSessionMock) // inject our testable mock service
        browseVC.networkTask?.cancel()
        browseVC.fetchPhotoList(photoService)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            XCTAssert(self?.browseVC.collectionView.numberOfItems(inSection: 0) == 2)
            let collView = self?.browseVC.collectionView!
            let cell = collView!.dataSource?.collectionView(collView!, cellForItemAt:IndexPath.init(item: 0, section: 0)) as! PhotoCell
            self?.photoCell = cell
            XCTAssertNotNil(self?.photoCell)
            testExpectation.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
        
    }

}
