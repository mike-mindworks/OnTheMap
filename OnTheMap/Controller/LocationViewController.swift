//
//  LocationViewController.swift
//  OnTheMap
//
//  Created by Mike Allan on 2020-08-03.
//  Copyright © 2020 Mindworks Software Design, Inc. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        //OnTheMapModel.studentLocations = hardCodedLocationData()
        weak var locVC = self
        _ = OTMClient.getStudentLocations() { studentLocations, error in
            OnTheMapModel.studentLocations = studentLocations
            locVC!.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refresh()
    }
    
    @IBAction func refresh() {
        weak var locVC = self
        _ = OTMClient.getStudentLocations() { studentLocations, error in
            OnTheMapModel.studentLocations = studentLocations
            locVC!.tableView.reloadData()
        }
    }

    @IBAction func logout(_ sender: Any) {
        weak var pvc = self.presentingViewController as? LoginViewController
        _ = OTMClient.logout() { (loggedOut, error) in
            pvc?.emailTextfield.text? = ""
            pvc?.passwordTextfield.text? = ""
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension LocationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OnTheMapModel.studentLocations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)

        // Configure the cell...
        let studentLocation = OnTheMapModel.studentLocations[(indexPath as NSIndexPath).row]
        var name: String?
        if let firstName = studentLocation.firstName {
            name = firstName + " "
        }
        if let lastName = studentLocation.lastName {
            if let startOfName = name {
                name = startOfName + " " + lastName
            }
            else {
                name = lastName
            }
        }
        cell.textLabel?.text = name
        
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = studentLocation.mediaURL
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocation = OnTheMapModel.studentLocations[(indexPath as NSIndexPath).row]
        if let mediaURL = studentLocation.mediaURL {
            let app = UIApplication.shared
            var targetURL: String
            if !mediaURL.hasPrefix("http") {
                targetURL = "https://" + mediaURL
            }
            else {
                targetURL = mediaURL
            }
            app.open(URL(string: targetURL)!)
        }
    }

}
