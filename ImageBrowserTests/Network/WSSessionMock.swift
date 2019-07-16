//
//  WSSessionMock.swift
//  ImageBrowserTests
//
//  Created by Mike Jones on 7/14/19.
//  Copyright © 2019 Mike Jones. All rights reserved.
//

import XCTest
@testable import ImageBrowser


//
// MARK: - Mock network layer for testing i.e. re-route outbound requests to local data
//
class WSSessionMock: WSSessionProtocol {
    
    // inject local JSON for unit testing purposes
    public func downloadJSON<T:Decodable>(_ endpoint: WSEndpointProtocol, responseType: T.Type, callback: @escaping WSCompletionHandler<T>) -> URLSessionDataTask? {
        let jsonTestData = "[{\"albumId\":1,\"id\":1,\"title\":\"t1\",\"url\":\"p1A.com\",\"thumbnailUrl\":\"p1B.com\"},{\"albumId\":2,\"id\":2,\"title\":\"t2\",\"url\":\"p2A.com\",\"thumbnailUrl\":\"p2B.com\"}]"
        let data = Data(jsonTestData.utf8)
        let decoded: WSResponse<T> = endpoint.decode(with: data, decodingType: T.self)
        switch decoded {
        case .success(let result):
            callback(.success(result))
        case .error(let error):
            callback(.error(WSError.parseError(error)))
        }
        return nil
    }
    
    // inject local image for unit testing purposes
    public func downloadImage(_ link: String, success: @escaping (UIImage) -> Void, failure: @escaping (WSError) -> Void) -> URLSessionDataTask? {
        guard let testImage = UIImage(named: "testImage") else {
            failure(WSError.unknownError)
            return nil
        }
        success(testImage)
        return nil
    }
}
