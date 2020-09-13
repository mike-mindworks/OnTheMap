//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Mike Allan on 2020-08-01.
//  Copyright © 2020 Mindworks Software Design, Inc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var newAccountTextview: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Clear the fields on the page
        emailTextfield.text = ""
        passwordTextfield.text = ""
        
        // Add a TapGestureRecognizer so the keyboard will close
        // when you exit the textfields
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let url = URL(string: "https://auth.udacity.com/sign-up")!
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let attributedString = NSMutableAttributedString(string: "Don't have an account? Sign Up", attributes: [.paragraphStyle: paragraph])
        
        let range = NSMakeRange(23, 7)
        attributedString.setAttributes([.link: url], range: range)

        newAccountTextview.attributedText = attributedString
        newAccountTextview.linkTextAttributes = [
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
    }

    @IBAction func loginTapped(_ sender: UIButton) {
        guard let username = emailTextfield.text else {
            showLoginFailure(message: "You need to enter a username")
            emailTextfield.becomeFirstResponder()
            return
        }
        if username.count == 0 {
            showLoginFailure(message: "You need to enter your username")
            emailTextfield.becomeFirstResponder()
            return
        }
        guard let password = passwordTextfield.text else {
            showLoginFailure(message: "You need to enter a password")
            passwordTextfield.becomeFirstResponder()
            return
        }
        if password.count == 0 {
            showLoginFailure(message: "You need to enter your password")
            passwordTextfield.becomeFirstResponder()
            return
        }
        
        emailTextfield.becomeFirstResponder()
        setLoggingIn(true)
        OTMClient.login(username: username, password: password, completion: self.handleLoginResponse(success:error:))
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        loggingIn ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    func handleLoginResponse(success: LoginResponse?, error: Error?) {
        setLoggingIn(false)
        
        if let success = success {
            print("Login successful!")
            OnTheMapModel.userAccount = success.account
            OnTheMapModel.loginName = self.emailTextfield.text
            OTMClient.getUserDetails(completion: self.handleUserDetailsResponse(userData:error:))
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
        }
        else {
            showLoginFailure(message: error?.localizedDescription ?? "(No localized description for error)")
        }
    }
    
    func handleUserDetailsResponse(userData: User?, error: Error?) {
        
        if let userData = userData {
            OnTheMapModel.user = userData
        }
        else {
            let alertVC = UIAlertController(title: "Could Not Retrieve User Data", message: error?.localizedDescription, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            show(alertVC, sender: nil)
        }
        
    }

    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
}

