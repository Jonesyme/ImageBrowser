//
//  Photo.swift
//  ImageBrowser
//
//  Created by Mike Jones on 7/13/19.
//  Copyright © 2019 Mike Jones. All rights reserved.
//

import Foundation
import UIKit

//
// MARK: - Codable Photo Object
//

// typicocde photo node
public class Photo: Codable {
    var id: Int
    var albumId: Int
    var title: String?
    var url: String
    var thumbnailUrl: String
}
