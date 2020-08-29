//
//  StudentLocationResponse.swift
//  OnTheMap
//
//  Created by Mike Allan on 2020-08-04.
//  Copyright © 2020 Mindworks Software Design, Inc. All rights reserved.
//

import Foundation

struct StudentLocationResponse: Codable {
    
    let results: [StudentLocation]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}
