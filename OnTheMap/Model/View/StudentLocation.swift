//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Mike Allan on 2020-08-03.
//  Copyright © 2020 Mindworks Software Design, Inc. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    
    // MARK: Properties
    
    let objectId: String?
    let uniqueKey: String?
    let firstName: String?
    let lastName:String?
    let mapString: String?
    let mediaURL:String?
    let latitude: Double?
    let longitude: Double?
    
    let objectIdKey = "objectIdKey"
    let uniqueKeyKey = "uniqueKey"
    let firstNameKey = "firstName"
    let lastNameKey = "lastName"
    let mapStringKey = "mapString"
    let mediaURLKey = "mediaURL"
    let latitudeKey = "latitude"
    let longitudeKey = "longitude"

    // MARK: Initializer

    init(dictionary: [String : Any]?) {
        self.objectId = dictionary?[objectIdKey] as? String
        self.uniqueKey = dictionary?[uniqueKeyKey] as? String
        self.firstName = dictionary?[firstNameKey] as? String
        self.lastName = dictionary?[lastNameKey] as? String
        self.mapString = dictionary?[mapStringKey] as? String
        self.mediaURL = dictionary?[mediaURLKey] as? String
        self.latitude = dictionary?[latitudeKey] as? Double
        self.longitude = dictionary?[longitudeKey] as? Double
    }
}
