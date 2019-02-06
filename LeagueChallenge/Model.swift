//
//  Model.swift
//  LeagueChallenge
//
//  Created by fernando marto on 2019-02-02.
//  Copyright © 2019 f. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class Model {
    

    static let shared = Model()
    
    var theUsers = [ [String:Any] ]() //users model
    var users: [NSManagedObject] = []
    
    var thePosts = [ [String:Any] ]() //posts model
    var posts: [NSManagedObject] = []
    
    var userAlbum = [ [String:Any] ]() //album model
    var albums: [NSManagedObject] = []

    var albumPhotos = [ [String:Any] ]() //photos model
    
    func updateModel( completion: @escaping (String?, Error?) -> Void) {
        
        APIController.shared.fetchUserToken(userName: "", password: "") { (result, theError) in
            
            APIController.shared.request(url: URL(string: APIController.shared.postsAPI)!) { [unowned self] (postsResult, theError) in
                
                if let thePostsX = postsResult as? [ [String:Any] ] {
                    
                    self.thePosts = thePostsX
                    
                    for aPost in thePostsX {
                        
                        if let theId = aPost["id"] as? Int,
                            let theUserId = aPost["userId"] as? Int,
                            let theTitle = aPost["title"] as? String,
                            let theBody = aPost["body"] as? String {
                            
                            self.savePost(id: theId, userId: theUserId, title: theTitle, body: theBody)
                        }
                        else {
                            print("Could not save post!")
                        }
                    }
                }
                
                APIController.shared.request(url: URL(string: APIController.shared.usersAPI)!) { [unowned self] (usersResult, theError) in
                    
                    if let theUsersX = usersResult as? [ [String:Any] ] {
                        
                        self.theUsers = theUsersX
                       
                        for aUser in theUsersX {
                        
                            if let theId = aUser["id"] as? Int,
                                let theName = aUser["name"] as? String,
                                let theEmail = aUser["email"] as? String,
                                let thePhone = aUser["phone"] as? String,
                                let theWebsite = aUser["website"] as? String,
                                let theAvatar = aUser["avatar"] as? [String:Any],
                                let theImageUrl = theAvatar["medium"] as? String,
                                let theCompany = aUser["company"] as? [String:Any],
                                let theCompanyName = theCompany["name"] as? String,
                                let theCompanyCatchPhrase = theCompany["catchPhrase"] as? String,
                                let theCompanyBs = theCompany["bs"] as? String {
                            
                                self.saveUser(id: theId, name: theName, email: theEmail, imageurl: theImageUrl, phone: thePhone, website: theWebsite, companyName: theCompanyName, companyCatchPhrase: theCompanyCatchPhrase, companyBs: theCompanyBs)
                            }
                            else {
                               print("Could not save user!")
                            }
                        }
                    }
                    
                    completion("updated", nil)
                }
            }
        }
    }
    
    
    
    
    func updateAlbum( userID: Int, completion: @escaping (String?, Error?) -> Void) {
    
        let urlString = APIController.shared.userAlbum + "?userId=" + String(userID)
        
        APIController.shared.request(url: URL(string: urlString)!) { [unowned self] (albumsResult, theError) in
        
            if let theAlbumList = albumsResult as? [ [String:Any] ] {
            
                self.userAlbum = theAlbumList
                
                for aAlbum in theAlbumList {
                    
                    if let theId = aAlbum["id"] as? Int,
                        let theUserId = aAlbum["userId"] as? Int,
                        let theTitle = aAlbum["title"] as? String {
                        
                        self.saveAlbum(id: theId, userId: theUserId, title: theTitle)
                    }
                    else {
                        print("Could not save album!")
                    }
                }
                
                completion("updated", nil)
            }
            
        }
    
    }
    
    func updatePhotos( albumID: Int, completion: @escaping (String?, Error?) -> Void) {
        
        let urlString = APIController.shared.userPhotos + "?albumId=" + String(albumID)
        
        APIController.shared.request(url: URL(string: urlString)!) { [unowned self] (albumsResult, theError) in
            
            if let theAlbumPhotoList = albumsResult as? [ [String:Any] ] {
                
                self.albumPhotos = theAlbumPhotoList
                
                completion("updated", nil)
            }
            
        }
        
    }
    
    
    //MARK: - Core Data
    
    func getUserCompanyBs(id: Int) -> String {
        
        var resultString = ""
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return resultString
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Users")
        fetchRequest.fetchLimit = 1
        
        let thePredicate = NSPredicate(format: "id == %@", argumentArray: [id])
        fetchRequest.predicate = thePredicate
        //fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: false)]
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result {
                resultString = data.value(forKey: "companyBs") as! String
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return resultString
    }
    
    func getUserCompanyCatchPhrase(id: Int) -> String {
        
        var resultString = ""
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return resultString
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Users")
        fetchRequest.fetchLimit = 1
        
        let thePredicate = NSPredicate(format: "id == %@", argumentArray: [id])
        fetchRequest.predicate = thePredicate
        //fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: false)]
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result {
                resultString = data.value(forKey: "companyCatchPhrase") as! String
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return resultString
    }
    
    func getUserCompanyName(id: Int) -> String {
        
        var resultString = ""
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return resultString
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Users")
        fetchRequest.fetchLimit = 1
        
        let thePredicate = NSPredicate(format: "id == %@", argumentArray: [id])
        fetchRequest.predicate = thePredicate
        //fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: false)]
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result {
                resultString = data.value(forKey: "companyName") as! String
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return resultString
    }
    
    func getUserWebsite(id: Int) -> String {
        
        var resultString = ""
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            return resultString
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Users")
        fetchRequest.fetchLimit = 1
        
        let thePredicate = NSPredicate(format: "id == %@", argumentArray: [id])
        fetchRequest.predicate = thePredicate
        //fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: false)]
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result {
                resultString = data.value(forKey: "website") as! String
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return resultString
    }


    func getUserPhone(id: Int) -> String {
        
        var resultString = ""
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            return resultString
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Users")
        fetchRequest.fetchLimit = 1
        
        let thePredicate = NSPredicate(format: "id == %@", argumentArray: [id])
        fetchRequest.predicate = thePredicate
        //fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: false)]
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result {
                resultString = data.value(forKey: "phone") as! String
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return resultString
    }

    func getUserEmail(id: Int) -> String {
        
        var resultString = ""
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            return resultString
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Users")
        fetchRequest.fetchLimit = 1
        
        let thePredicate = NSPredicate(format: "id == %@", argumentArray: [id])
        fetchRequest.predicate = thePredicate
        //fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: false)]
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result {
                resultString = data.value(forKey: "email") as! String
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return resultString
    }

    func getUserName(id: Int) -> String {
        
        var resultString = ""
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            return resultString
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Users")
        fetchRequest.fetchLimit = 1
        
        let thePredicate = NSPredicate(format: "id == %@", argumentArray: [id])
        fetchRequest.predicate = thePredicate
        //fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: false)]
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result {
                resultString = data.value(forKey: "name") as! String
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return resultString
    }

    func getUserImageUrl(id: Int) -> String {
        
        var resultString = ""
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            return resultString
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Users")
        fetchRequest.fetchLimit = 1
        
        let thePredicate = NSPredicate(format: "id == %@", argumentArray: [id])
        fetchRequest.predicate = thePredicate
        //fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: false)]
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result {
                resultString = data.value(forKey: "imageurl") as! String
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return resultString
    }
    
    func getAlbums() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Albums")
        
        do {
            albums = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func getPosts() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Posts")
        
        do {
            posts = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func getUsers() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Users")
        
        do {
            users = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    func saveAlbum(id: Int, userId: Int, title: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Albums", in: managedContext)!
        
        let album = NSManagedObject(entity: entity, insertInto: managedContext)
        
        album.setValue(id, forKeyPath: "id")
        album.setValue(userId, forKeyPath: "userId")
        album.setValue(title, forKeyPath: "title")
        
        do {
            try managedContext.save()
            albums.append(album)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func savePost(id: Int, userId: Int, title: String, body: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Posts", in: managedContext)!
        
        let post = NSManagedObject(entity: entity, insertInto: managedContext)
        
        post.setValue(id, forKeyPath: "id")
        post.setValue(userId, forKeyPath: "userId")
        post.setValue(title, forKeyPath: "title")
        post.setValue(body, forKeyPath: "body")
        
        do {
            try managedContext.save()
            posts.append(post)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func saveUser(id: Int, name: String, email: String, imageurl: String, phone: String, website: String, companyName: String, companyCatchPhrase: String, companyBs: String ) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Users", in: managedContext)!
        
        let user = NSManagedObject(entity: entity, insertInto: managedContext)
        
        user.setValue(id, forKeyPath: "id")
        user.setValue(name, forKeyPath: "name")
        user.setValue(email, forKeyPath: "email")
        user.setValue(imageurl, forKeyPath: "imageurl")
        user.setValue(phone, forKeyPath: "phone")
        user.setValue(website, forKeyPath: "website")
        user.setValue(companyName, forKeyPath: "companyName")
        user.setValue(companyCatchPhrase, forKeyPath: "companyCatchPhrase")
        user.setValue(companyBs, forKeyPath: "companyBs")
        
        do {
            try managedContext.save()
            users.append(user)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}
