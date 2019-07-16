//
//  BrowseVCTests.swift
//  ImageBrowserTests
//
//  Created by Mike Jones on 7/14/19.
//  Copyright © 2019 Mike Jones. All rights reserved.
//

import XCTest
@testable import ImageBrowser


class BrowseVCTests: XCTestCase {

    var browseVC: BrowseVC!
    var window: UIWindow!

    override func setUp() {
        window = UIWindow()
        browseVC = AppDelegate.mainStoryboard.instantiateViewController(withIdentifier: "browseVC") as? BrowseVC
        browseVC.photoService = PhotoService(WSSessionMock())
        window.addSubview(browseVC.view)
        RunLoop.current.run(until: Date())
    }

    func testSetupOK() {
        XCTAssertNotNil(browseVC)
    }
    
    func testUIComponents() {
        XCTAssertNotNil(browseVC?.collectionView)
    }

    func testFetchPhotoList() {
        browseVC.networkTask?.cancel() // cancel any previous fetch invoked by loading view
        let testExpectation = expectation(description: #function)
        let photoServiceMock = PhotoService(WSSessionMock()) // inject our testable mock service
        browseVC.fetchPhotoList(photoServiceMock)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            XCTAssert(self?.browseVC.collectionView.numberOfItems(inSection: 0) == 2)
            testExpectation.fulfill()
        }
        waitForExpectations(timeout: 3.0, handler: nil)
    }
}
