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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let post = post {
            let user = post["author"] as! PFUser
            userLabel.text = user.username!
            
            let caption = post["caption"] as! String
            captionLabel.text = caption
            
            let likeCount = post["likesCount"] as! Int
            likesLabel.text = String(likeCount) + " likes"
            
            self.instagramPost = post
            
            let timeStamp = post.createdAt as! Date
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            let dateString = dateFormatter.string(from: timeStamp)
            timestampLabel.text = dateString
            
        
        }
        
        
        
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
