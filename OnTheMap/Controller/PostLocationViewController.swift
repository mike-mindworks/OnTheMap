//
//  PostLocationViewController.swift
//  OnTheMap
//
//  Created by Mike Allan on 2020-08-16.
//  Copyright © 2020 Mindworks Software Design, Inc. All rights reserved.
//

import UIKit
import MapKit

class PostLocationViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var location: StudentLocation?
    var annotation: MKPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let annotation = annotation {
            self.mapView.addAnnotation(annotation)
        }
    }
    
    @IBAction func back(_ sender: Any) {
        for controller in self.navigationController!.viewControllers {
            if controller is AddLocationViewController {
                if let alvc = controller as? AddLocationViewController {
                    alvc.locationLabel.text = ""
                    self.navigationController!.popToViewController(alvc, animated: true)
                }
            }
        }
    }
    
    @IBAction func postLocation(_ sender: Any) {
        if let location = self.location {
            OTMClient.postLocation(location: location, completion: self.handlePostLocationResponse(response:error:))
        }
    }
    
    func handlePostLocationResponse(response: PostLocationResponse?, error: Error?) {
        if let error = error {
            print("Error in handlePostLocationResponse: \(error)")
            for controller in self.navigationController!.viewControllers {
                if controller.isKind(of: AddLocationViewController.self) {
                    if let alvc = controller as? AddLocationViewController {
                        alvc.locationLabel.text = error.localizedDescription
                        self.navigationController!.popToViewController(alvc, animated: true)
                    }
                }
            }
            // Default action
            self.navigationController?.popToRootViewController(animated: true)
            return
        }
        print("PostLocation was successful")
        
        // Refresh the locations collection
        _ = OTMClient.getStudentLocations() { studentLocations, error in
            OnTheMapModel.studentLocations = studentLocations
        }
        print("Location collection refreshed")

        // Segue to the MapView
        self.dismiss(animated: true)
    }
    
}
