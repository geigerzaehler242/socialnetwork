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
    
    
    
}
