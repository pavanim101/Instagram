//
//  PostCollectionViewCell.swift
//  Instagram
//
//  Created by Pavani Malli on 6/28/17.
//  Copyright © 2017 Pavani Malli. All rights reserved.
//

import UIKit
import ParseUI
import Parse

class PostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postImageView: PFImageView!
    
    var instagramPost: PFObject! {
        didSet {
            self.postImageView.file = instagramPost["media"] as? PFFile
            self.postImageView.loadInBackground()
        }
    }
    
}
