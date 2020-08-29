//
//  ErrorResponse.swift
//  OnTheMap
//
//  Created by Mike Allan on 2020-08-01.
//  Copyright © 2020 Mindworks Software Design, Inc. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable {
    let code: Int
    let error: String
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
