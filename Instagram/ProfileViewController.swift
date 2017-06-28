//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Pavani Malli on 6/28/17.
//  Copyright © 2017 Pavani Malli. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts: [PFObject] = []
    
  
    @IBOutlet weak var userLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
       
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.queryParse), userInfo: nil, repeats: true)

        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellsPerLine: CGFloat = 3;
        let interItemSpacing = layout.minimumInteritemSpacing
        let width = collectionView.frame.size.width / cellsPerLine - interItemSpacing
        layout.itemSize = CGSize(width: width, height: width * 1)
        
        let user = PFUser.current()
        userLabel.text = user!.username
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logOut(_ sender: UIButton) {
        
        PFUser.logOutInBackground { (error:Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
            } else {
                let Login = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
                self.present(Login, animated: true, completion: nil)
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.posts.count
        
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PostCollectionViewCell
        

        
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
                self.collectionView.reloadData()
                
            }
            else {
                print(error!.localizedDescription)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! PostCollectionViewCell
        if let indexPath = collectionView.indexPath(for: cell){
            let post = posts[indexPath.row]
            let postDetailViewController = segue.destination as! DetailViewController
            postDetailViewController.post = post
        }

}

}
