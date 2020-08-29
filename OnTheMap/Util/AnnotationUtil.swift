//
//  AnnotationUtil.swift
//  OnTheMap
//
//  Created by Mike Allan on 2020-08-16.
//  Copyright © 2020 Mindworks Software Design, Inc. All rights reserved.
//

import Foundation
import MapKit

class AnnotationUtil {
    
    class func convertStudentLocationToAnnotation(studentLocation: StudentLocation) -> MKPointAnnotation {
        // Notice that the float values are being used to create CLLocationDegree values.
        // This is a version of the Double type.
        let lat = CLLocationDegrees(studentLocation.latitude!)
        let long = CLLocationDegrees(studentLocation.longitude!)
        
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let first = studentLocation.firstName!
        let last = studentLocation.lastName!
        let mediaURL = studentLocation.mediaURL
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(first) \(last)"
        annotation.subtitle = mediaURL
        
        return annotation
    }
    
    class func convertStudentLocationToLocationAnnotation(studentLocation: StudentLocation) -> MKPointAnnotation {
        // Notice that the float values are being used to create CLLocationDegree values.
        // This is a version of the Double type.
        let lat = CLLocationDegrees(studentLocation.latitude!)
        let long = CLLocationDegrees(studentLocation.longitude!)
        
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let locationName = studentLocation.mapString
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = locationName
        
        return annotation
    }
}
