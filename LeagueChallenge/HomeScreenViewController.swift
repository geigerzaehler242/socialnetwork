//
//  HomeScreenViewController.swift
//  LeagueChallenge
//
//  Created by fernando marto on 2019-02-02.
//  Copyright © 2019 f. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
    
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    private let refreshControl = UIRefreshControl()

    var thePosts = [ [String:Any] ]() //posts model
    var theUsers = [ [String:Any] ]() //users model
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        postsTableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(refreshPostsTable), for: .valueChanged)
    
        navigationController?.visibleViewController?.title = "Posts"
    
        refreshPostsTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        
    }
    
    
    @objc private func refreshPostsTable() {
        
        activitySpinner.startAnimating()
        
        APIController.shared.fetchUserToken(userName: "", password: "") { (result, theError) in
            
            APIController.shared.request(url: URL(string: APIController.shared.postsAPI)!) { [unowned self] (postsResult, theError) in
                
                if let thePostsX = postsResult as? [ [String:Any] ] {
                    self.thePosts = thePostsX
                }
                
                APIController.shared.request(url: URL(string: APIController.shared.usersAPI)!) { [unowned self] (usersResult, theError) in
                    
                    if let theUsersX = usersResult as? [ [String:Any] ] {
                        self.theUsers = theUsersX
                    }
                    
                    self.activitySpinner.stopAnimating()
                    self.refreshControl.endRefreshing()
                    self.postsTableView.reloadData()
                }
            
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

extension HomeScreenViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thePosts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostsTableViewCell", for:indexPath) as! PostsTableViewCell
        
            if let thePostUserId = self.thePosts[indexPath.row]["userId"] as? Int, thePostUserId > 0,
            let thePostUserAvatar = self.theUsers[thePostUserId - 1]["avatar"] as? [String:Any],
                let thePostUserImageURLString = thePostUserAvatar["medium"] as? String {
                
                APIController.shared.fetchImage(url: URL(string: thePostUserImageURLString)! ){ /*[unowned self]*/ (imageResult, theError) in
                    
                    if let theUserImage = imageResult as? UIImage {
                        
                        DispatchQueue.main.async {
                            cell.postUserImage.image = theUserImage.af_imageRoundedIntoCircle()
                        }
                    }
                }
                
            }
            else {
                cell.postUserImage.image = nil //can set generic image in future
            }
            
            if let thePostUserId = self.thePosts[indexPath.row]["userId"] as? Int, thePostUserId > 0,
                let thePostUserName = self.theUsers[thePostUserId - 1]["name"] as? String {
        
                cell.postUserName.text = thePostUserName
            }
            else {
                cell.postUserName.text = ""
            }
            
            if let thePostTitle = self.thePosts[indexPath.row]["title"] as? String {
                
                cell.postTitle.text = thePostTitle
            }
            else {
                cell.postTitle.text = ""
            }
            
            if let thePostBody = self.thePosts[indexPath.row]["body"] as? String {
                
                cell.postText.text = thePostBody
            }
            else {
                cell.postText.text = ""
            }
        
        return cell
        
    }
    
    
    
    
    
    
    
}
