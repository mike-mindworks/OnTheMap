//
//  UdacityErrorResponse.swift
//  OnTheMap
//
//  Created by Mike Allan on 2020-08-23.
//  Copyright © 2020 Mindworks Software Design, Inc. All rights reserved.
//

import Foundation

struct UdacityErrorResponse: Codable {
    let status: Int
    let error: String
}

extension UdacityErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
