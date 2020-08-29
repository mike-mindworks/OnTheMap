//
//  PostLocation.swift
//  OnTheMap
//
//  Created by Mike Allan on 2020-08-16.
//  Copyright © 2020 Mindworks Software Design, Inc. All rights reserved.
//

import Foundation

struct PostLocation: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String?
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case uniqueKey
        case firstName
        case lastName
        case mapString
        case mediaURL
        case latitude
        case longitude
    }

}
