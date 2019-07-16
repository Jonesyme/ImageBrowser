//
//  DetailVCTests.swift
//  ImageBrowserTests
//
//  Created by Mike Jones on 7/14/19.
//  Copyright © 2019 Mike Jones. All rights reserved.
//

import XCTest
@testable import ImageBrowser


class DetailVCTests: XCTestCase {

    var detailVC: DetailVC!
    var window: UIWindow!
    
    override func setUp() {
        window = UIWindow()
        detailVC = AppDelegate.mainStoryboard.instantiateViewController(withIdentifier: "detailVC") as? DetailVC
        window.addSubview(detailVC.view)
        RunLoop.current.run(until: Date())
    }

    func testSetupOK() {
        XCTAssertNotNil(detailVC)
    }

    func testUIComponents() {
        XCTAssertNotNil(detailVC?.activitySpinner)
        XCTAssertNotNil(detailVC?.imageView)
    }

    func testFetchFullSizePhoto() {
        // assign mock PhotoStore to detailVC
        let data = Data("{\"albumId\":1,\"id\":1,\"title\":\"\",\"url\":\"\",\"thumbnailUrl\":\"\"}".utf8)
        let photo: Photo? = try? JSONDecoder().decode(Photo.self, from: data)
        detailVC.photoStore = photo!
        
        let photoServiceMock = PhotoService(WSSessionMock()) // inject our testable mock service
        detailVC.photoService = photoServiceMock
        
        // fetch full-size image
        let testImg = UIImage(named: "testImage")!
        let testExpectation = expectation(description: #function)
        detailVC.fetchFullSizeImage()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            XCTAssertNotNil(self?.detailVC.imageView.image)
            XCTAssert(self?.detailVC.imageView.image?.pngData() == testImg.pngData())
            testExpectation.fulfill()
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
}
