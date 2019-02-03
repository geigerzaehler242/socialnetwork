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
    
    var postIndex = 0
    
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
            
        
//            let attributedString = NSMutableAttributedString(string: thePostUserUrl)
//            attributedString.addAttribute(.link, value: thePostUserUrl, range: NSRange(location: 0, length: thePostUserUrl.count))
//            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: thePostUserUrl.count))
//
//
//            userUrl.attributedText = attributedString
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

//extension ProfileViewController : UITextViewDelegate {
//    
//    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
//        UIApplication.shared.open(URL, options: [:])
//        return false
//    }
//}
