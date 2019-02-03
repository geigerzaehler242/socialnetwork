//
//  ProfileViewController.swift
//  LeagueChallenge
//
//  Created by fernando marto on 2019-02-02.
//  Copyright © 2019 f. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userEmail: UITextView!
    
    @IBOutlet weak var userPhone: UITextView!
    
    @IBOutlet weak var userUrl: UITextView!
    
    @IBOutlet weak var innerFrame: UIView!
    
    @IBOutlet weak var albumCollectionView: UICollectionView!
    
    
    @IBOutlet weak var shadeView: UIView!
    
    @IBOutlet weak var photoImage: UIImageView!
    
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    var tapGesture = UITapGestureRecognizer()
    var swipeGestureLeft = UISwipeGestureRecognizer()
    var swipeGestureRight = UISwipeGestureRecognizer()
    
    var photoIndex = 0
    
    var postIndex = 0
    
    var postUserId: Int = 0 {
        
        didSet {
            
            Model.shared.updateAlbum(userID: postUserId) { [unowned self] (imageResult, theError) in

                self.albumCollectionView.reloadData()
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationController?.visibleViewController?.title = "User Profile"
        
        innerFrame.layer.cornerRadius = 20
        
        if let thePostUserId = Model.shared.thePosts[postIndex]["userId"] as? Int, thePostUserId > 0,
            let thePostUserAvatar = Model.shared.theUsers[thePostUserId - 1]["avatar"] as? [String:Any],
            let thePostUserImageURLString = thePostUserAvatar["medium"] as? String {
            
            APIController.shared.fetchImage(url: URL(string: thePostUserImageURLString)! ){ [unowned self] (imageResult, theError) in
                
                if let theUserImage = imageResult as? UIImage {
                    
                    DispatchQueue.main.async {
                        self.userImage.image = theUserImage.af_imageRoundedIntoCircle()
                    }
                }
            }
            
        }
        else {
            userImage.image = nil //can set generic image in future
        }
        
        if let thePostUserId = Model.shared.thePosts[postIndex]["userId"] as? Int, thePostUserId > 0,
            let thePostUserName = Model.shared.theUsers[thePostUserId - 1]["name"] as? String {
            
            userName.text = thePostUserName
            
        }
        else {
            userName.text = ""
        }
        
        if let thePostUserId = Model.shared.thePosts[postIndex]["userId"] as? Int, thePostUserId > 0,
            let thePostUserEmail = Model.shared.theUsers[thePostUserId - 1]["email"] as? String {
            
            userEmail.text = thePostUserEmail
            
        }
        else {
            userEmail.text = ""
        }
        
        if let thePostUserId = Model.shared.thePosts[postIndex]["userId"] as? Int, thePostUserId > 0,
            let thePostUserPhone = Model.shared.theUsers[thePostUserId - 1]["phone"] as? String {
            
            userPhone.text = thePostUserPhone
            
        }
        else {
            userPhone.text = ""
        }
        
        if let thePostUserId = Model.shared.thePosts[postIndex]["userId"] as? Int, thePostUserId > 0,
            let thePostUserUrl = Model.shared.theUsers[thePostUserId - 1]["website"] as? String {
            
           userUrl.text = thePostUserUrl
            
        }
        else {
            userUrl.text = ""
        }
        
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(myviewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        
        shadeView.addGestureRecognizer(tapGesture)
        
        swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(myviewSwippedLeft(_:)))
        swipeGestureLeft.direction = .left
        shadeView.addGestureRecognizer(swipeGestureLeft)
        
        swipeGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(myviewSwippedRight(_:)))
        swipeGestureRight.direction = .right
        shadeView.addGestureRecognizer(swipeGestureRight)
    }
    
    @objc func myviewTapped(_ sender: UITapGestureRecognizer) {
        
        shadeView.isHidden = true
        photoImage.isHidden = true
    }
    
    @objc func myviewSwippedRight(_ sender: UISwipeGestureRecognizer) {
        
        if sender.state == .ended {
            
            if sender.direction == .right {
                
                if photoIndex > 0 {
                    photoIndex -= 1
                }
                
                refreshPhoto()
            }
            
        }
        
    }
    
    @objc func myviewSwippedLeft(_ sender: UISwipeGestureRecognizer) {
        
        if sender.state == .ended {
            
            if sender.direction == .left {
                
                photoIndex += 1
                
                refreshPhoto()
                
            }
            else {
                
                if photoIndex > 0 {
                   photoIndex -= 1
                }
                
                refreshPhoto()
            }
        }
        
    }
    
    func refreshPhoto() {
        
        if let thePhotoUrlString = Model.shared.albumPhotos[photoIndex]["url"] as? String {
            
            APIController.shared.fetchImage(url: URL(string: thePhotoUrlString)! ){ [unowned self] (imageResult, theError) in
                
                if let thePhotoImage = imageResult as? UIImage {
                    
                    DispatchQueue.main.async {
                        self.photoImage.image = thePhotoImage
                    }
                }
            }
        }
        else {
            DispatchQueue.main.async {
                self.photoImage.image = nil //can set generic image in future
            }
        }
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProfileViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return Model.shared.userAlbum.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        //since the API doesn't seem to allow to download only one photo then just show album title on the cell
        //otherwise downloading full photo collections to just show the first photo image on each cell is a
        //potential huge bandwidth issue.
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCollectionViewCell", for: indexPath) as! AlbumCollectionViewCell
        
        if Model.shared.userAlbum.count > 0, let albumTitle = Model.shared.userAlbum[indexPath.row]["title"] as? String {
            cell.title.text = albumTitle
        }
        else {
            cell.title.text = ""
        }
        
        cell.backgroundColor = UIColor(displayP3Red: CGFloat.random(in: 0 ... 1), green: CGFloat.random(in: 0 ... 1), blue: CGFloat.random(in: 0 ... 1), alpha: 1.0)
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        photoIndex = 0
        
        shadeView.isHidden = false
        photoImage.isHidden = false
        self.activitySpinner.startAnimating()
        
        if let theAlbumId = Model.shared.userAlbum[0]["id"] as? Int {
            
            Model.shared.updatePhotos( albumID: theAlbumId) { [unowned self] (updateResult, theError) in
                
                self.activitySpinner.stopAnimating()
                
                if let thePhotoUrlString = Model.shared.albumPhotos[self.photoIndex]["url"] as? String {
                
                    APIController.shared.fetchImage(url: URL(string: thePhotoUrlString)! ){ [unowned self] (imageResult, theError) in
                        
                        if let thePhotoImage = imageResult as? UIImage {
                            
                            DispatchQueue.main.async {
                                self.photoImage.image = thePhotoImage
                            }
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.photoImage.image = nil //can set generic image in future
                    }
                }
            }
        }
        else {
            photoImage.image = nil //can set generic image in future
        }
    }
    
    
}
