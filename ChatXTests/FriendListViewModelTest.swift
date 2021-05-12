//
//  FriendListViewModelTest.swift
//  ChatXTests
//
//  Created by Piyush Kant on 2021/05/12.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking

@testable import ChatX

let fakeUser1 = User(user: ["email" : "fakeUser1_email", "fullname" : "fakeUser1_fullname", "username" : "fakeUser1_username", "profileImageURL" : "fakeUser1_profileImageURL", "uid" : "fakeUser1_uid"])
let fakeUser2 = User(user: ["email" : "fakeUser2_email", "fullname" : "fakeUser2_fullname", "username" : "fakeUser2_username", "profileImageURL" : "fakeUser2_profileImageURL", "uid" : "fakeUser2_uid"])

class FriendListViewModelTest : XCTestCase {
    var viewModel: FriendListViewModel!
    var scheduler: ConcurrentDispatchQueueScheduler!
    
    override func setUp() {
        super.setUp()
        
        var fakeUsers = [User]()
        fakeUsers.append(fakeUser1!)
        fakeUsers.append(fakeUser2!)
        
        let fakeService = FakeAPIService(fakeUsers: fakeUsers)
        
        viewModel = FriendListViewModel(service: fakeService)
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
    }
    
    func testFetchUsers() throws {
        let users = viewModel.users.asObservable().subscribe(on: scheduler)
        
        let fetchedUsers = try users.toBlocking(timeout: 1.0).first()
        
        let fetchedUser1 = fetchedUsers![0]
        XCTAssertEqual(fetchedUser1.email, "fakeUser1_email")
        XCTAssertEqual(fetchedUser1.fullname, "fakeUser1_fullname")
        XCTAssertEqual(fetchedUser1.username, "fakeUser1_username")
        XCTAssertEqual(fetchedUser1.profileImageUrl, "fakeUser1_profileImageURL")
        XCTAssertEqual(fetchedUser1.uid, "fakeUser1_uid")
     
        let fetchedUser2 = fetchedUsers![1]
        XCTAssertEqual(fetchedUser2.email, "fakeUser2_email")
        XCTAssertEqual(fetchedUser2.fullname, "fakeUser2_fullname")
        XCTAssertEqual(fetchedUser2.username, "fakeUser2_username")
        XCTAssertEqual(fetchedUser2.profileImageUrl, "fakeUser2_profileImageURL")
        XCTAssertEqual(fetchedUser2.uid, "fakeUser2_uid")
    }
}

