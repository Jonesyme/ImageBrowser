//
//  PhotoServiceTests.swift
//  ImageBrowserTests
//
//  Created by Mike Jones on 7/14/19.
//  Copyright © 2019 Mike Jones. All rights reserved.
//

import XCTest
@testable import ImageBrowser


class PhotoServiceTests: XCTestCase {

    var photoService = PhotoService(WSSessionMock())
    var photo: Photo?
    
    override func setUp() {
        // generate Photo from fake JSON
        let data = Data("{\"albumId\":1,\"id\":1,\"title\":\"\",\"url\":\"\",\"thumbnailUrl\":\"\"}".utf8)
        photo = try? JSONDecoder().decode(Photo.self, from: data)
    }
    
    func testPhotoStoreIsValid() {
        XCTAssertNotNil(photo)
    }
    
    func testFetchingThumbnailImage() {
        let testExpectation = expectation(description: #function)
        var testImage: UIImage?
        let _ = photoService.fetchThumb(photo!, callback: { result in
            switch result {
            case .error(let error):
                XCTFail(error.localizedDescription)
            case .success(let image):
                testImage = image
                testExpectation.fulfill()
            }
        })
        waitForExpectations(timeout: 3.0, handler: nil)
        XCTAssertNotNil(testImage)
        XCTAssert(testImage?.size.height == 300)
        XCTAssert(testImage?.size.width == 500)
        
    }

    func testFetchingFullSizeImage() {
        let testExpectation = expectation(description: #function)
        var testImage: UIImage?
        let _ = photoService.fetchFullSize(photo!, callback: { result in
            switch result {
            case .error(let error):
                XCTFail(error.localizedDescription)
            case .success(let image):
                testImage = image
                testExpectation.fulfill()
            }
        })
        waitForExpectations(timeout: 3.0, handler: nil)
        XCTAssertNotNil(testImage)
        XCTAssert(testImage?.size.height == 300)
        XCTAssert(testImage?.size.width == 500)
        
    }
    
}
