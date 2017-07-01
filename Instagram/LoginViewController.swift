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
    
    
    @IBAction func tapGesture(_ sender: Any) {
        view.endEditing(true)
    }
    
    //Checks that fields are not empty before creating a new user
    @IBAction func registerUser(_ sender: UIButton) {
        if usernameField.text!.isEmpty || passwordField.text!.isEmpty {
            self.usernameError()        }
            
        else{
            let newUser = PFUser()
            
            newUser.username = usernameField.text
            newUser.password = passwordField.text

            newUser.signUpInBackground {(success: Bool, error: Error?) in
                if let error = error {
                    self.signupError()
                    print("Sign up error!" + error.localizedDescription)
                    
                } else {
                    print("User Registered Succesfully")
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
                
            }
        }

    }
    
    //Checks that fields are not empty and that the login info is valid before logging in
    @IBAction func logInUser(_ sender: UIButton) {
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        
        
        if username.isEmpty || password.isEmpty {
            self.usernameError()
        }
        
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user:PFUser?, error:Error?) in
            if let error = error {
                    print("User log in failed: \(error.localizedDescription)")
                    self.usernameError()
                } else {
                    print("User logged in succesfully")
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
            }
        }
    
    
    
    //Methods for error notifications with sign up or log in
    func usernameError() {
        let alertController = UIAlertController(title: "Invalid User Information", message: "Please try again", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            }
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true) {
            
        }
        
    }
    
    func signupError() {
        let alertController = UIAlertController(title: "Invalid Username", message: "Please choose a different username", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                    }
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true) {
            }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
