//
//  Model.swift
//  LeagueChallenge
//
//  Created by fernando marto on 2019-02-02.
//  Copyright © 2019 f. All rights reserved.
//

import Foundation



class Model {
    

    static let shared = Model()
    
    var thePosts = [ [String:Any] ]() //posts model
    var theUsers = [ [String:Any] ]() //users model
    
    
    func updateModel( completion: @escaping (String?, Error?) -> Void) {
        
        
        APIController.shared.fetchUserToken(userName: "", password: "") { (result, theError) in
            
            APIController.shared.request(url: URL(string: APIController.shared.postsAPI)!) { [unowned self] (postsResult, theError) in
                
                if let thePostsX = postsResult as? [ [String:Any] ] {
                    self.thePosts = thePostsX
                }
                
                APIController.shared.request(url: URL(string: APIController.shared.usersAPI)!) { [unowned self] (usersResult, theError) in
                    
                    if let theUsersX = usersResult as? [ [String:Any] ] {
                        self.theUsers = theUsersX
                    }
                    
                    completion("updated", nil)
                }
                
            }
            
        }
        
        
        
        
    }
    
    
    
}
