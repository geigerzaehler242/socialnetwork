//
//  APIController.swift
//  LeagueMobileChallenge
//
//  Created by Kelvin Lau on 2019-01-14.
//  Copyright © 2019 Kelvin Lau. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class APIController {
    
    static let user = "user"
    static let password = "password"
    
    static let domain = "https://engineering.league.com/challenge/api/"
    let loginAPI = domain + "login"
    let postsAPI = domain + "posts"
    let usersAPI = domain + "users"
    let userAlbum = domain + "albums"
    let userPhotos = domain + "photos"
    
    static let shared = APIController()
    
    fileprivate var userToken: String?
    
    func fetchUserToken(userName: String, password: String, completion: @escaping (String?, Error?) -> Void) {
        guard let url = URL(string: loginAPI) else {
            return
        }
        var headers: HTTPHeaders = [:]
        
        if let authorizationHeader = Request.authorizationHeader(user: userName, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        Alamofire.request(url, headers: headers).responseJSON { (response) in
            guard response.error == nil else {
                completion(nil, response.error)
                return
            }
            
            if let value = response.result.value as? [AnyHashable : Any] {
                self.userToken = value["api_key"] as? String
            }
            completion(self.userToken, nil)
        }
    }
    
    func request(url: URL, completion: @escaping (Any?, Error?) -> Void) {
        guard let userToken = userToken else {
            NSLog("No user token set")
            completion(nil, nil)
            return
        }
        let authHeader: HTTPHeaders = ["x-access-token" : userToken]
        
        Alamofire.request(url, method: .get
            , parameters: nil, encoding: URLEncoding.default, headers: authHeader).responseJSON { (response) in
                completion(response.result.value, response.error)
        }
    }
    
//    func requestX(url: URL, completion: @escaping (Any?, Error?) -> Int) {
//        guard let userToken = userToken else {
//            NSLog("No user token set")
//            completion(nil, nil)
//            return
//        }
//        let authHeader: HTTPHeaders = ["x-access-token" : userToken]
//        
//        Alamofire.request(url, method: .get
//            , parameters: nil, encoding: URLEncoding.default, headers: authHeader).responseJSON { (response) in
//                completion(response.result.value, response.error)
//        }
//    }
    
    func fetchImage(url: URL, completion: @escaping (Any?, Error?) -> Void) {
        Alamofire.request(url).responseImage { response in
            
            completion(response.result.value, response.error)
        }
    }
    
}
