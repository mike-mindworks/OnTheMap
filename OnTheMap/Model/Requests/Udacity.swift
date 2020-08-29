//
//  Udacity.swift
//  OnTheMap
//
//  Created by Mike Allan on 2020-08-01.
//  Copyright © 2020 Mindworks Software Design, Inc. All rights reserved.
//

import Foundation

struct Udacity: Codable {
    let username: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
    }
}
