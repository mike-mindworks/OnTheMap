//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Mike Allan on 2020-08-01.
//  Copyright © 2020 Mindworks Software Design, Inc. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    let udacity: Udacity
    
    enum CodingKeys: String, CodingKey {
        case udacity
    }
}
