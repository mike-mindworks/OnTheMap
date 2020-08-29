//
//  PostLocationResponse.swift
//  OnTheMap
//
//  Created by Mike Allan on 2020-08-16.
//  Copyright © 2020 Mindworks Software Design, Inc. All rights reserved.
//

import Foundation

struct PostLocationResponse: Codable {
    let objectId: String

    enum CodingKeys: String, CodingKey {
        case objectId
    }
}
