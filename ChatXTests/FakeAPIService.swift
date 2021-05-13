//
//  FakeAPIService.swift
//  ChatXTests
//
//  Created by Piyush Kant on 2021/05/12.
//

import RxSwift

@testable import ChatX

class FakeAPIService: APIServiceProtocol {

    private var fakeUser: User?
    private var fakeUsers: [User]?
    private var fakeConversations: [Conversation]?
    private var fakeMessages: [Message]?
    
    init(fakeUser: User) {
        self.fakeUser = fakeUser
    }
    
    init(fakeUsers: [User]) {
        self.fakeUsers = fakeUsers
    }
    
    init(fakeConversations: [Conversation]) {
        self.fakeConversations = fakeConversations
    }
    
    init(fakeMessages: [Message]) {
        self.fakeMessages = fakeMessages
    }
    
    func fetchUser(uid: String) -> Observable<User?> {
        return Observable.just(self.fakeUser)
    }
    
    func fetchUsers() -> Observable<[User]> {
        return Observable.just(self.fakeUsers!)
    }
    
    func fetchConversations() -> Observable<[Conversation]> {
        return Observable.just(self.fakeConversations!)
    }
    
    func fetchMessages(forUser user: User) -> Observable<[Message]> {
        return Observable.just(self.fakeMessages!)
    }
    
    func uploadMessage(_ message: String, To user: User?) -> Observable<Bool> {
        return Observable.just(true)
    }
}
