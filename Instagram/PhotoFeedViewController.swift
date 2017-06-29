//
//  PhotoFeedViewController.swift
//  Instagram
//
//  Created by Pavani Malli on 6/27/17.
//  Copyright © 2017 Pavani Malli. All rights reserved.
//

//TODO:  likes, progress loading, infinite scrolling, camera/filters, auto layout, aesthetics
import UIKit
import Parse
import ParseUI

class PhotoFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var postsTableView: UITableView!
    
    var posts: [PFObject] = []
    var isMoreDataLoading = false;
    var queryLimit: Int = 20
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.startAnimating()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector (PhotoFeedViewController.didPullToRefresh(_:)), for: .valueChanged)
        
        postsTableView.insertSubview(refreshControl, at:0)

        
        postsTableView.dataSource = self
        postsTableView.delegate = self
        
        // Fetch messages every second
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.queryParse), userInfo: nil, repeats: true)
    

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        queryParse()
        
        self.postsTableView.reloadData()
        
        refreshControl.endRefreshing()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.posts.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        
        let user = posts[indexPath.row]["author"] as! PFUser
        cell.userNameLabel.text = user.username!

        let caption = posts[indexPath.row]["caption"] as! String
        cell.captionLabel.text = caption
        
        
        let likeCount = posts[indexPath.row]["likesCount"] as! Int
        if likeCount == 1 {
        cell.likesLabel.text = String(likeCount) + " like"
            } else{
                cell.likesLabel.text = String(likeCount) + " likes"
        }
        
        cell.instagramPost = posts[indexPath.row]
        
        cell.currentID = posts[indexPath.row].objectId
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! PostTableViewCell
        if let indexPath = postsTableView.indexPath(for: cell){
            let post = posts[indexPath.row]
            let postDetailViewController = segue.destination as! DetailViewController
            postDetailViewController.post = post
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading){
            let scrollViewContentHeight = postsTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - postsTableView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && postsTableView.isDragging) {
                isMoreDataLoading = true
                self.queryLimit += 20
                
            }
        }
    }
    
    func queryParse() {
        let query = PFQuery(className: "Post")
        query.addDescendingOrder("createdAt")
        query.includeKey("author")
        query.limit = self.queryLimit
        
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let posts = posts {
                self.posts = posts
                self.postsTableView.reloadData()
                
            }
            else {
                print(error!.localizedDescription)
            }
        }
        
        self.isMoreDataLoading = false
        activityIndicator.stopAnimating()
    }
    
}
