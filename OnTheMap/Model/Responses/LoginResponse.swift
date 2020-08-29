//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Mike Allan on 2020-08-01.
//  Copyright © 2020 Mindworks Software Design, Inc. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
    
    enum CodingKeys: String, CodingKey {
        case account
        case session
    }
}
