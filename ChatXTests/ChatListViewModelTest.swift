//
//  ChatListViewModelTest.swift
//  ChatXTests
//
//  Created by Piyush Kant on 2021/05/13.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking

@testable import ChatX

let fakeCoversation1 = Conversation(user: fakeUser1!, recentMessage: fakeMessage1)
let fakeCoversation2 = Conversation(user: fakeUser2!, recentMessage: fakeMessage2)

class ChatListViewModelTest : XCTestCase {
    var viewModel: ChatListViewModel!
    var scheduler: ConcurrentDispatchQueueScheduler!
    
    override func setUp() {
        super.setUp()
        
        var fakeConversations = [Conversation]()
        fakeConversations.append(fakeCoversation1)
        fakeConversations.append(fakeCoversation2)
        
        let fakeService = FakeAPIService(fakeConversations: fakeConversations)
        viewModel = ChatListViewModel(service: fakeService)
        
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
    }
    
    func testFetchConversations() throws {
        let users = viewModel.conversations.asObservable().subscribe(on: scheduler)
        
        let fetchedConversations = try users.toBlocking(timeout: 1.0).first()
        
        let fetchedConversation1User = fetchedConversations![0].user
        XCTAssertEqual(fetchedConversation1User.email, "fakeUser1_email")
        XCTAssertEqual(fetchedConversation1User.fullname, "fakeUser1_fullname")
        XCTAssertEqual(fetchedConversation1User.username, "fakeUser1_username")
        XCTAssertEqual(fetchedConversation1User.profileImageUrl, "fakeUser1_profileImageURL")
        XCTAssertEqual(fetchedConversation1User.uid, "fakeUser1_uid")
        
        let fetchedConversation1RecentMessage = fetchedConversations![0].recentMessage
        XCTAssertEqual(fetchedConversation1RecentMessage.text, "fakeMessage1_text")
        XCTAssertEqual(fetchedConversation1RecentMessage.toId, "fakeMessage1_toId")
        XCTAssertEqual(fetchedConversation1RecentMessage.fromId, "fakeMessage1_fromId")
        
        let fetchedConversation2User = fetchedConversations![1].user
        XCTAssertEqual(fetchedConversation2User.email, "fakeUser2_email")
        XCTAssertEqual(fetchedConversation2User.fullname, "fakeUser2_fullname")
        XCTAssertEqual(fetchedConversation2User.username, "fakeUser2_username")
        XCTAssertEqual(fetchedConversation2User.profileImageUrl, "fakeUser2_profileImageURL")
        XCTAssertEqual(fetchedConversation2User.uid, "fakeUser2_uid")

        let fetchedConversation2RecentMessage = fetchedConversations![1].recentMessage
        XCTAssertEqual(fetchedConversation2RecentMessage.text, "fakeMessage2_text")
        XCTAssertEqual(fetchedConversation2RecentMessage.toId, "fakeMessage2_toId")
        XCTAssertEqual(fetchedConversation2RecentMessage.fromId, "fakeMessage2_fromId")
    }
}
