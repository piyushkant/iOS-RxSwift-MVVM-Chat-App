//
//  ChatViewModelTest.swift
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

let fakeMessage1 = Message(dic: ["text" : "fakeMessage1_text", "toId": "fakeMessage1_toId", "fromId" : "fakeMessage1_fromId"])
let fakeMessage2 = Message(dic: ["text" : "fakeMessage2_text", "toId": "fakeMessage2_toId", "fromId" : "fakeMessage2_fromId"])

class ChatViewModelTest : XCTestCase {
    var viewModel: ChatViewModel!
    var scheduler: ConcurrentDispatchQueueScheduler!
    
    override func setUp() {
        super.setUp()
        
        var fakeMessages = [Message]()
        fakeMessages.append(fakeMessage1)
        fakeMessages.append(fakeMessage2)
        
        let fakeService = FakeAPIService(fakeMessages: fakeMessages)
        
        viewModel = ChatViewModel(user: fakeUser1!, service: fakeService)
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
    }
    
    func testFetchMessages() throws {
        let users = viewModel.messages.asObservable().subscribe(on: scheduler)
        
        let fetchedMessages = try users.toBlocking(timeout: 1.0).first()
        
        let fetchedMessage1 = fetchedMessages![0]
        XCTAssertEqual(fetchedMessage1.text, "fakeMessage1_text")
        XCTAssertEqual(fetchedMessage1.toId, "fakeMessage1_toId")
        XCTAssertEqual(fetchedMessage1.fromId, "fakeMessage1_fromId")
     
        let fetchedMessage2 = fetchedMessages![1]
        XCTAssertEqual(fetchedMessage2.text, "fakeMessage2_text")
        XCTAssertEqual(fetchedMessage2.toId, "fakeMessage2_toId")
        XCTAssertEqual(fetchedMessage2.fromId, "fakeMessage2_fromId")
    }
}
