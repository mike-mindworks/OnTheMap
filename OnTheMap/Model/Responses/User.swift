//
//  User.swift
//  OnTheMap
//
//  Created by Mike Allan on 2020-08-23.
//  Copyright © 2020 Mindworks Software Design, Inc. All rights reserved.
//

import Foundation

struct User: Codable {
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
