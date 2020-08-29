//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Mike Allan on 2020-08-16.
//  Copyright © 2020 Mindworks Software Design, Inc. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {

    @IBOutlet weak var geocodeString: UITextField!
    @IBOutlet weak var websiteUrl: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var findLocationButton: UIButton!
    
    var newLocation: StudentLocation?
    lazy var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func findLocation(_ sender: Any) {
        self.view.endEditing(true)
        if let address = geocodeString.text {
            geocoder.geocodeAddressString(address, completionHandler: getGeocodeResponse)
        }
    }

    func getGeocodeResponse( geocodes: [CLPlacemark]?, error: Error?) {
        if let error = error {
            print("Error returned for geocode string: \(error.localizedDescription)")
            locationLabel.text = "Unable to find a Location for this Address"
            return
        }

        var location: CLLocation?
        if let geocodes = geocodes {
            location = geocodes.first?.location
        }
        if let location = location {
            let coordinate = location.coordinate
            locationLabel.text = "Latitude: \(coordinate.latitude),  Longitude: \(coordinate.longitude)"
            // At this point we need to post the new location
            // with the username to the onthemap API
            print("Posting new location")
            self.newLocation = StudentLocation(dictionary: ["firstName" : OnTheMapModel.user?.firstName ?? "", "lastName" : OnTheMapModel.user?.lastName ?? "", "mapString" : geocodeString.text ?? "", "mediaURL" : websiteUrl?.text ?? "", "latitude" : coordinate.latitude, "longitude" : coordinate.longitude])
            performSegue(withIdentifier: "mapViewSegue", sender: self)
        }
        else {
            locationLabel.text = "No Matching Location Found"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapViewSegue" {
            let destinationController = segue.destination as! PostLocationViewController
            destinationController.location = self.newLocation
            destinationController.annotation = AnnotationUtil.convertStudentLocationToLocationAnnotation(studentLocation: self.newLocation!)
        }
    }
}
