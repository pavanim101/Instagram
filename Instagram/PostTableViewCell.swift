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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
