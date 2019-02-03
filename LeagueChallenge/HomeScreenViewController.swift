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
    
    
    @IBAction func didTapUsername(_ sender: UIButton) {
   
//        let cell = sender.superview as! UITableViewCell
//        let indexPath = tableView.indexPathForCell(cell)
        
        performSegue(withIdentifier: "viewUserProfileSegue", sender: sender)
        
    }
    
    
    
    @objc private func refreshPostsTable() {
        
        activitySpinner.startAnimating()
        
        Model.shared.updateModel() { (result, theError) in
         
            self.activitySpinner.stopAnimating()
            self.refreshControl.endRefreshing()
            self.postsTableView.reloadData()
            
        }
        

    }
    

    
    //MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let theSender = sender as? UIButton,
            let destinationVC =  segue.destination as? ProfileViewController {
            
            destinationVC.postIndex = theSender.tag //selected post row
            
        }
        
        
    }
    

}

//MARK: - Extension

extension HomeScreenViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.shared.thePosts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostsTableViewCell", for:indexPath) as! PostsTableViewCell
        
            if let thePostUserId = Model.shared.thePosts[indexPath.row]["userId"] as? Int, thePostUserId > 0,
            let thePostUserAvatar = Model.shared.theUsers[thePostUserId - 1]["avatar"] as? [String:Any],
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
            
            if let thePostUserId = Model.shared.thePosts[indexPath.row]["userId"] as? Int, thePostUserId > 0,
                let thePostUserName = Model.shared.theUsers[thePostUserId - 1]["name"] as? String {
        
                cell.postUserName.setTitle(thePostUserName, for: .normal)
                cell.postUserName.tag = indexPath.row
            }
            else {
                cell.postUserName.setTitle("", for: .normal)
            }
            
            if let thePostTitle = Model.shared.thePosts[indexPath.row]["title"] as? String {
                
                cell.postTitle.text = thePostTitle
            }
            else {
                cell.postTitle.text = ""
            }
            
            if let thePostBody = Model.shared.thePosts[indexPath.row]["body"] as? String {
                
                cell.postText.text = thePostBody
            }
            else {
                cell.postText.text = ""
            }
        
        return cell
        
    }
    
    
    
    
    
    
    
}
