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
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var photoImageView: PFImageView!
    
    @IBOutlet weak var timestampLabel: UILabel!
    
    
    @IBOutlet weak var likesLabel: UILabel!
    
    
    @IBOutlet weak var captionLabel: UILabel!
    
    var instagramPost: PFObject! {
        didSet {
            self.photoImageView.file = instagramPost["media"] as? PFFile
            self.photoImageView.loadInBackground()
        }
    }
    
    var currentID: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.fetchPostData), userInfo: nil, repeats: true)
    }
    
    
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
    
    func fetchPostData() {
        if let post = post {
            let user = post["author"] as! PFUser
            userLabel.text = user.username!
            
            let caption = post["caption"] as! String
            captionLabel.text = caption
            
            let likeCount = post["likesCount"] as! Int
            if likeCount == 1 {
                likesLabel.text = String(likeCount) + " like"
            } else {
                likesLabel.text = String(likeCount) + " likes"
            }
            
            
            
            self.instagramPost = post
            
            let timeStamp = post.createdAt as! Date
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            let dateString = dateFormatter.string(from: timeStamp)
            timestampLabel.text = dateString
            
            
        }
    }

    

}
