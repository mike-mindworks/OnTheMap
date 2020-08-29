//
//  UserData.swift
//  OnTheMap
//
//  Created by Mike Allan on 2020-08-23.
//  Copyright © 2020 Mindworks Software Design, Inc. All rights reserved.
//

import Foundation

struct UserData: Codable {
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case user
    }
}
