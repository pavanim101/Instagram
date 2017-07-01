//
//  NewPostViewController.swift
//  Instagram
//
//  Created by Pavani Malli on 6/26/17.
//  Copyright © 2017 Pavani Malli. All rights reserved.
//

import UIKit
import MBProgressHUD
import Sharaku

class NewPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var captionTextField: UITextField!
    
    var photoToPost: UIImage!
    
    var captionString: String!
    
    var sourceType: String!
    
    @IBAction func tapGesture(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets properties to inital imageView
        self.photoImageView.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        
        self.photoImageView.layer.borderWidth = 2
        
        //OPens up photo library or camera depending on device availibity
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            vc.sourceType = .camera
        } else {
            vc.sourceType = .photoLibrary
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Sets selected or captured image to the imageView and photo parameter variable to save to Parse
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let imageData = UIImageJPEGRepresentation(originalImage, 0.2)!
        
        self.photoImageView.image = originalImage
        self.photoImageView.layer.borderColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1.0).cgColor
        self.photoToPost = UIImage(data: imageData)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    //If selectPhoto button is clicked
    @IBAction func selectPhoto(_ sender: UIButton) {
        self.openPhotoSource(source: "photoLibrary")
    }
    
    //If takePhoto button is clicked
    @IBAction func takePhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.openPhotoSource(source: "camera")
        } else {
            self.cameraError()
        }
    }
    
    //Method that opens either camerea or photo library depending on paramter
    func openPhotoSource(source:String){
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        
        if source == "camera" {
            vc.sourceType = UIImagePickerControllerSourceType.camera
        } else{
            vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    //If post button is clicked, passes in necessary parameters to postUserImage() to send data to Parse
    @IBAction func createPost(_ sender: UIButton) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        print("about to post")
        self.captionString = captionTextField.text ?? ""
        print(self.captionString)
        
        Post.postUserImage(image: self.photoToPost, withCaption: self.captionString, withCompletion: { (success, error) in
            if success {
                print("Post was saved!")
                MBProgressHUD.hide(for: self.view, animated: true)
                
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        })
        
        captionTextField.text = ""
    }
    
    //Alert notification if camera is not available
    func cameraError() {
        let alertController = UIAlertController(title: "Camera not available", message: "Please select from photo library", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            // handle cancel response here. Doing nothing will dismiss the view.
        }
        // add the cancel action to the alertController
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true) {
            // optional code for what happens after the alert controller has finished presenting
        }
        
    }
    
}
