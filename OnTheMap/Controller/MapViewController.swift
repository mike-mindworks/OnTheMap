//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Mike Allan on 2020-08-02.
//  Copyright © 2020 Mindworks Software Design, Inc. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var annotations = [MKPointAnnotation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self

        // Do any additional setup after loading the view.
        _ = OTMClient.getStudentLocations() { studentLocations, error in
            OnTheMapModel.studentLocations = studentLocations
        }
        
        // Convert the locations to annotations and add them to the map.
        self.mapView.addAnnotations(getAnnotations(locations: OnTheMapModel.studentLocations))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.refresh(self)
    }
    
    func getAnnotations(locations: [StudentLocation]) -> [MKPointAnnotation] {
        
        var annotations = [MKPointAnnotation]()

        for studentLocation in locations {
            
            let annotation = AnnotationUtil.convertStudentLocationToAnnotation(studentLocation: studentLocation)
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
    
        return annotations
    }
    
    @IBAction func refresh(_ sender: Any) {
        weak var mvc = self
        _ = OTMClient.getStudentLocations() { studentLocations, error in
            OnTheMapModel.studentLocations = studentLocations
            if let oldAnnotations = mvc?.annotations {
                mvc?.mapView.removeAnnotations(oldAnnotations)
            }
            if let newAnnotations = mvc?.getAnnotations(locations: OnTheMapModel.studentLocations) {
                mvc?.annotations = newAnnotations
                mvc?.mapView.addAnnotations(newAnnotations)
            }
        }
        
    }
    
    @IBAction func logout(_ sender: Any) {
        _ = OTMClient.logout() { (loggedOut, error) in
            weak var pvc = self.presentingViewController as? LoginViewController
            pvc?.emailTextfield.text? = ""
            pvc?.passwordTextfield.text? = ""
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - MKMapViewDelegate

    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation!.subtitle {
                var targetURL: String
                if !toOpen!.hasPrefix("http") {
                    targetURL = "https://" + toOpen!
                }
                else {
                    targetURL = toOpen!
                }
                app.open(URL(string: targetURL)!)
            }
        }
    }
    
}
