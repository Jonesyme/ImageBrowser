//
//  WebServiceTests.swift
//  ImageBrowserTests
//
//  Created by Mike Jones on 7/14/19.
//  Copyright © 2019 Mike Jones. All rights reserved.
//

import XCTest
@testable import ImageBrowser

//
// WebService Tests
//
class WebServiceTests: XCTestCase {

    let photoService = PhotoService(WSSessionMock()) // inject mock network session
    var photoList:[Photo] = []

    func testParsingJSONData() {
        let testExpectation = expectation(description: #function)
        let _ = photoService.webSession.downloadJSON(TCEndpoint.photos, responseType: [Photo].self) { [weak self] result in
            switch result {
            case .error(let error):
                print(error)
                XCTFail()
            case .success(let response):
                self?.photoList.append(contentsOf: response)
                XCTAssert(self?.photoList.count==2)
                
                guard let photo = self?.photoList[0] else {
                    XCTFail()
                    return
                }
                XCTAssert(photo.id == 1)
                XCTAssert(photo.albumId == 1)
                XCTAssert(photo.title == "t1")
                XCTAssert(photo.url == "p1A.com")
                XCTAssert(photo.thumbnailUrl == "p1B.com")
                
                guard let photo2 = self?.photoList[1] else {
                    XCTFail()
                    return
                }
                XCTAssert(photo2.id == 2)
                XCTAssert(photo2.albumId == 2)
                XCTAssert(photo2.title == "t2")
                XCTAssert(photo2.url == "p2A.com")
                XCTAssert(photo2.thumbnailUrl == "p2B.com")
                
                testExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 3.0, handler: nil)
    }

}
