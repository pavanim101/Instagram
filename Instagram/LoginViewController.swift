//
//  LoginViewController.swift
//  Instagram
//
//  Created by Pavani Malli on 6/26/17.
//  Copyright © 2017 Pavani Malli. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

   
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    
    
    @IBAction func registerUser(_ sender: UIButton) {
        let newUser = PFUser()
        
        newUser.username = usernameField.text ?? ""
        newUser.password = passwordField.text ?? ""
        
        if usernameField.text!.isEmpty || passwordField.text!.isEmpty {
            self.usernameError()
        }
        else{
            newUser.signUpInBackground {(success: Bool, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                    
                } else {
                    print("User Registered Succesfully")
                    self.performSegue(withIdentifier: "signupSegue", sender: nil)
                }
                
            }
        }

    }
    
    
    @IBAction func logInUser(_ sender: UIButton) {
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        
        
        if username.isEmpty || password.isEmpty {
            self.usernameError()
        }
        else {
            print("logging in")
            PFUser.logInWithUsername(inBackground: username, password: password) { (user:PFUser?, error:Error?) in
                if let error = error {
                    print("User log in failed: \(error.localizedDescription)")
                } else {
                    print("User logged in succesfully")
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
            }
        }
    
    }
    
    
    func usernameError() {
        let alertController = UIAlertController(title: "Empty username or password", message: "Please enter a username and password", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            // handle cancel response here. Doing nothing will dismiss the view.
        }
        // add the cancel action to the alertController
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true) {
            // optional code for what happens after the alert controller has finished presenting
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
