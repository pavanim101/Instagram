//
//  NewPostViewController.swift
//  Instagram
//
//  Created by Pavani Malli on 6/26/17.
//  Copyright © 2017 Pavani Malli. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var captionTextField: UITextField!
    
    var photoToPost: UIImage!
    
    var captionString: String!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.openCameraRoll()
        
        self.captionString = captionTextField.text
        // Do any additional setup after loading the view.
    }

   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        

        photoImageView.image = originalImage
        self.photoToPost = originalImage
        
        dismiss(animated: true, completion: nil)
    }

    
    @IBAction func selectPhoto(_ sender: UIButton) {
        self.openCameraRoll()
    }

    func openCameraRoll(){
    let vc = UIImagePickerController()
    vc.delegate = self
    vc.allowsEditing = true
    vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
    
    print("opened")
    self.present(vc, animated: true, completion: nil)
    
    }

    @IBAction func createPost(_ sender: UIButton) {
        print("about to post")
        Post.postUserImage(image: self.photoToPost, withCaption: self.captionString, withCompletion: { (success, error) in
            if success {
                print("The message was saved!")
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        })
    }




}
