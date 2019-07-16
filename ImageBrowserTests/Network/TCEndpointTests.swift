//
//  TCEndpointTests.swift
//  ImageBrowserTests
//
//  Created by Mike Jones on 7/14/19.
//  Copyright © 2019 Mike Jones. All rights reserved.
//

import XCTest
@testable import ImageBrowser

class TCEndpointTests: XCTestCase {

    func testTCEndpointValues() {
        XCTAssert(TCEndpoint.photos.scheme == "https")
        XCTAssert(TCEndpoint.photos.host == "jsonplaceholder.typicode.com")
        XCTAssert(TCEndpoint.photos.path == "/photos")
        XCTAssert(TCEndpoint.photos.params.count == 0)
    }

}
