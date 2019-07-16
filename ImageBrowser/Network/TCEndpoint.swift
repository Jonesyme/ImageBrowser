//
//  TCEndpoint.swift
//  ImageBrowser
//
//  Created by Mike Jones on 7/13/19.
//  Copyright © 2019 Mike Jones. All rights reserved.
//

import Foundation
import UIKit

//
// MARK: - TypiCode WebService Endpoint
//
public enum TCEndpoint {
    case photos
}

extension TCEndpoint: WSEndpointProtocol {

    public var scheme: String {
        return "https" // NOTE: SSL used in liu of original URL in order to avoid transport security override
    }
    
    public var host: String {
        return "jsonplaceholder.typicode.com"
    }

    public var path: String {
        switch self {
        case .photos:
            return "/photos"
        }
    }
    
    public var params: [URLQueryItem] {
        switch self {
        case .photos:
            return []
        }
    }
    
    public func decode<T:Decodable>(with data: Data, decodingType: T.Type) -> WSResponse<T> {
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedObject)
        } catch {
            return .error(WSError.parseError(error))
        }
    }
}

