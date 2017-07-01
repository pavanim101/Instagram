//
//  DetailViewController.swift
//  Instagram
//
//  Created by Pavani Malli on 6/28/17.
//  Copyright © 2017 Pavani Malli. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class DetailViewController: UIViewController {
    
    var post: PFObject!
    
    var currentID: String!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var photoImageView: PFImageView!
    
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var profileImageView: PFImageView!
    
    @IBOutlet weak var userCaptionLabel: UILabel!
    
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var captionLabel: UILabel!
    
    var instagramPost: PFObject! {
        didSet {
            self.photoImageView.file = instagramPost["media"] as? PFFile
            self.photoImageView.loadInBackground()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.activityIndicator.startAnimating()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Fetches data every second
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.fetchPostData), userInfo: nil, repeats: true)
    }
    
    //Updates the likeCount
    @IBAction func likePost(_ sender: UIButton) {
        let query = PFQuery(className: "Post")
        print("RUNNING")
        query.getObjectInBackground(withId: self.currentID) { (updatedObject: PFObject?,error: Error?) in
            if let updatedObject = updatedObject {
                print(self.currentID)
                updatedObject["likesCount"] = updatedObject["likesCount"] as! Int + 1
                updatedObject.saveInBackground()
                
            } else {
                print("Error with likes" + error!.localizedDescription)
            }
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Fetches data that is passed from segue
    func fetchPostData() {
        if let post = post {
            let user = post["author"] as! PFUser
            userLabel.text = user.username!
            userCaptionLabel.text = user.username!
            
            let caption = post["caption"] as! String
            captionLabel.text = caption
            
            let likeCount = post["likesCount"] as! Int
            if likeCount == 1 {
                likesLabel.text = String(likeCount) + " like"
            } else {
                likesLabel.text = String(likeCount) + " likes"
            }
            
            self.profileImageView.file = user["profilePic"] as? PFFile
            self.profileImageView.loadInBackground()
            
            profileImageView.layer.borderWidth=1.0
            profileImageView.layer.masksToBounds = false
            profileImageView.layer.borderColor = UIColor.white.cgColor
            profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2
            profileImageView.clipsToBounds = true
            
            
            self.instagramPost = post
            
            let timeStamp = post.createdAt!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            let dateString = dateFormatter.string(from: timeStamp)
            timestampLabel.text = dateString
            
            self.activityIndicator.stopAnimating()
        }
    }
    
}
