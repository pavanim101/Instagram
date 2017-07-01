//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Pavani Malli on 6/28/17.
//  Copyright © 2017 Pavani Malli. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileViewController: UIViewController, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts: [PFObject] = []
    
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var profilePicButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        self.activityIndicator.startAnimating()
    }
    
    @IBOutlet weak var profileImageView: PFImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
        //Fetches data every second
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.queryParse), userInfo: nil, repeats: true)
        
        //Collection view layour
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellsPerLine: CGFloat = 3;
        let interItemSpacing = layout.minimumInteritemSpacing
        let width = collectionView.frame.size.width / cellsPerLine - interItemSpacing
        layout.itemSize = CGSize(width: width, height: width * 1)
        
        //Populates user name and profile picture
        let user = PFUser.current()!
        userLabel.text = user.username
        
        if user["profilePic"] != nil {
            self.profileImageView.file = user["profilePic"] as? PFFile
            self.profileImageView.layer.borderWidth=1.0
            self.profileImageView.layer.borderColor = UIColor.white.cgColor
            self.profileImageView.layer.masksToBounds = false
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2
            self.profileImageView.clipsToBounds = true
            self.profileImageView.loadInBackground()
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    
    //Update profile picture
    @IBAction func changeProfilePic(_ sender: UIButton) {
        //imagePicker, save to Parse
        
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    //Opens photo library to select a new profile picture
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        profileImageView.image = originalImage
        
        let user = PFUser.current()!
        user["profilePic"] = Post.getPFFileFromImage(image: originalImage)
        user.saveInBackground()
        
        dismiss(animated: true, completion: nil)
    }
    
    //Log out, modal segue to log in screen
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
    
    //Populates the collection view with images specific to the user
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PostCollectionViewCell
        
        cell.instagramPost = posts[indexPath.row]
        
        return cell
        
    }
    
    //Fetches data from Parse
    func queryParse() {
        let query = PFQuery(className: "Post")
        query.addDescendingOrder("createdAt")
        query.includeKey("author")
        query.limit = 20
        if PFUser.current() != nil{
            query.whereKey("author", equalTo: PFUser.current()!)}
        
        
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let posts = posts {
                self.posts = posts
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
            }
            else {
                print(error!.localizedDescription)
            }
        }
        
    }
    
    //Passes data to detailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! PostCollectionViewCell
        if let indexPath = collectionView.indexPath(for: cell){
            let post = posts[indexPath.row]
            let postDetailViewController = segue.destination as! DetailViewController
            postDetailViewController.post = post
        }
        
    }
    
}
