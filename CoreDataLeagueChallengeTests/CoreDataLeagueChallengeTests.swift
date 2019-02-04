//
//  CoreDataLeagueChallengeTests.swift
//  CoreDataLeagueChallengeTests
//
//  Created by fernando marto on 2019-02-04.
//  Copyright © 2019 f. All rights reserved.
//

import XCTest
@testable import LeagueChallenge

var model: Model!

class CoreDataLeagueChallengeTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        model = Model()
        
        model.getPosts()
        model.getUsers()
        model.getAlbums()
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        model = nil
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let postCount = model.posts.count
        let usersCount = model.users.count
        let albumsCount = model.albums.count
        
        XCTAssertEqual(postCount, 4300, "post count is wrong") //500
        XCTAssertEqual(usersCount, 420, "users count is wrong") //50
        XCTAssertEqual(albumsCount, 2600, "album count is wrong") //200
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
