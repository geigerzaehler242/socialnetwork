//
//  ProfileViewController.swift
//  LeagueChallenge
//
//  Created by fernando marto on 2019-02-02.
//  Copyright © 2019 f. All rights reserved.
//

import UIKit

enum PanScrollDirection {
    case left, right
}

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
    
    var panGesture = UIPanGestureRecognizer()
    var gestureDirection: PanScrollDirection = .right
    
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
            
        let thePostUserImageURLString = Model.shared.getUserImageUrl(id: postUserId)
        
        APIController.shared.fetchImage(url: URL(string: thePostUserImageURLString)! ){ [unowned self] (imageResult, theError) in
            
            if let theUserImage = imageResult as? UIImage {
                
                DispatchQueue.main.async {
                    self.userImage.image = theUserImage.af_imageRoundedIntoCircle()
                }
            }
            else {
                self.userImage.image = nil //can set generic image in future
            }
        }
            
        let thePostUserName = Model.shared.getUserName(id: postUserId)
        
        userName.text = thePostUserName
            
        let thePostUserEmail = Model.shared.getUserEmail(id: postUserId)
        
        userEmail.text = thePostUserEmail
            
        let thePostUserPhone = Model.shared.getUserPhone(id: postUserId)
        
        userPhone.text = thePostUserPhone
            
        let thePostUserUrl = Model.shared.getUserWebsite(id: postUserId)
     
        userUrl.text = thePostUserUrl
        
        
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
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(myviewPanned(_:)))
        innerFrame.addGestureRecognizer(panGesture)
    }
    
    @objc func myviewTapped(_ sender: UITapGestureRecognizer) {
        
        shadeView.isHidden = true
        photoImage.isHidden = true
    }
    
    // MARK: Pan gesture
    
    @objc func myviewPanned(_ gesture: UIPanGestureRecognizer) {
        
        let velocity = gesture.velocity(in: innerFrame)
        let percent = gesture.translation(in: innerFrame).x/250
        var flipTransform3D = CATransform3DIdentity
        flipTransform3D.m34 = -1.0 / 1000.0
        
        switch gesture.state {
            
        case .began:
            
            gestureDirection = velocity.x > 0 ? .right : .left
            
        case .changed:
            
            if gestureDirection == .right { // Flip right
                
                switch percent {
                    
                case 0.0..<1.0:
                    flipTransform3D = CATransform3DRotate(flipTransform3D, CGFloat(-Double.pi) * percent, 0, 1, 0)
                    innerFrame.layer.transform = flipTransform3D
                    if percent >= 0.5 {
                        //self.userImage.isHidden = true
                        
                    }
                    else {
                        //self.userImage.isHidden = false
                        
                    }
                case 1.0...CGFloat(MAXFLOAT):
                    flipTransform3D = CATransform3DRotate(flipTransform3D, CGFloat(-Double.pi), 0, 1, 0)
                    innerFrame.layer.transform = flipTransform3D
                default:
                    print(percent)
                }
                
            }
            else { // Flip left
                
                switch percent {
                    
                case CGFloat(-MAXFLOAT)...(-1.0):
                    innerFrame.layer.transform = CATransform3DIdentity
                case -1.0...0:
                    if percent <= -0.5 {
                        //self.userImage.isHidden = false
                    }
                    else {
                        //self.userImage.isHidden = true
                    }
                    flipTransform3D = CATransform3DRotate(flipTransform3D, CGFloat(-Double.pi) * (percent), 0, 1, 0)
                    innerFrame.layer.transform = flipTransform3D
                default:
                    print(percent)
                }
            }
            
        case .ended:
            
            switch gestureDirection {
                
            case .right:
                if percent >= 0.5 {
                    
                    flipTransform3D = CATransform3DRotate(flipTransform3D, CGFloat(Double.pi), 0, 1, 0)
                    UIView.animate(withDuration: 0.3, animations: {
                       
                        self.innerFrame.layer.transform = flipTransform3D
                    }, completion: {
                        _ in

                    })
                }
                else {
                        let frontView = innerFrame! // cardArray[0]
                        UIView.animate(withDuration: 0.2, animations: {
                            frontView.layer.transform = CATransform3DIdentity
                        })
                }
                
            case .left:
                
                if percent <= -0.5 {

                        UIView.animate(withDuration: 0.2, animations: {

                            self.innerFrame.layer.transform = CATransform3DIdentity
                        }, completion: {
                            _ in

                        })
                }
                else {
                        UIView.animate(withDuration: 0.2, animations: {

                            self.innerFrame.layer.transform = CATransform3DRotate(flipTransform3D, CGFloat(-Double.pi), 0, 1, 0)
                        }, completion: {
                            _ in

                        })
                }
            }
        case .cancelled:
            gesture.isEnabled = true
        default:
            print("DEFAULT: DO NOTHING")
        }

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
        
        if Model.shared.albums.count == 0 {
            return 0
        }
        else {
            return Model.shared.albums.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        //since the API doesn't seem to allow to download only one photo then just show album title on the cell
        //otherwise downloading full photo collections to just show the first photo image on each cell is a
        //potential huge bandwidth issue.
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCollectionViewCell", for: indexPath) as! AlbumCollectionViewCell
        
        if Model.shared.albums.count > 0 {
            
            let theAlbum = Model.shared.albums[indexPath.row]
            if let albumTitle = theAlbum.value(forKeyPath: "title") as? String {
                cell.title.text = albumTitle
            }
            else {
                cell.title.text = ""
            }
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
        
        
        if let theAlbumId = Model.shared.albums[0].value(forKeyPath: "id") as? Int {
            
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
