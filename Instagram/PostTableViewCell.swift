//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by Pavani Malli on 6/27/17.
//  Copyright © 2017 Pavani Malli. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var photoImageView: PFImageView!
    
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var likesLabel: UILabel!
    
    var instagramPost: PFObject! {
        didSet {
            self.photoImageView.file = instagramPost["media"] as? PFFile
            self.photoImageView.loadInBackground()
        }
    }
    
    @IBOutlet weak var profileImageView: PFImageView!
    
    @IBOutlet weak var userCaptionLabel: UILabel!
    
    var currentID: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    //Updates the likeCount
    @IBAction func likePost(_ sender: UIButton) {
        let query = PFQuery(className: "Post")
        query.getObjectInBackground(withId: self.currentID) { (updatedObject: PFObject?,error: Error?) in
            if let updatedObject = updatedObject {
                updatedObject["likesCount"] = updatedObject["likesCount"] as! Int + 1
                updatedObject.saveInBackground()
                
            }
            
        }
    }
    
}
