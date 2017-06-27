//
//  Post.swift
//  Instagram
//
//  Created by Pavani Malli on 6/27/17.
//  Copyright © 2017 Pavani Malli. All rights reserved.
//

import UIKit
import Parse

class Post: NSObject {
    
    class func postUserImage(image: UIImage!, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        
        print("creating post object")
       
        let post = PFObject(className: "Post")
        
        print("saving media!")
        post["media"] = getPFFileFromImage(image: image)
        post["author"] = PFUser.current()
        post["caption"] = caption
        post["likesCount"] = 0
        post["commentsCount"] = 0
        
        print("about to save!")
        post.saveInBackground(block: completion)
        
    }
    
    
    class func getPFFileFromImage(image: UIImage!) -> PFFile? {
        // check if image is not nil
        print("converting image!")
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData as Data)
            }
        }
        return nil
    }

}
