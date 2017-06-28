//
//  PhotoFeedViewController.swift
//  Instagram
//
//  Created by Pavani Malli on 6/27/17.
//  Copyright © 2017 Pavani Malli. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PhotoFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var postsTableView: UITableView!
    
    var posts: [PFObject] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postsTableView.dataSource = self
        postsTableView.delegate = self
        
        // Fetch messages every second
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.queryParse), userInfo: nil, repeats: true)
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.posts.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        
        if posts[indexPath.row]["author"] != nil {
            let user = posts[indexPath.row]["author"] as! PFUser
            cell.userNameLabel.text = user.username!
            
        }
        
        let likeCount = posts[indexPath.row]["likesCount"] as! Int
        cell.likesLabel.text = String(likeCount) + " likes"
        
        cell.instagramPost = posts[indexPath.row]
        
        return cell
    }
    
    func queryParse() {
        let query = PFQuery(className: "Post")
        query.addDescendingOrder("createdAt")
        query.includeKey("author")
        query.limit = 20
        
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let posts = posts {
                self.posts = posts
                self.postsTableView.reloadData()
                
            }
            else {
                print(error!.localizedDescription)
            }
        }
    
    }
}
