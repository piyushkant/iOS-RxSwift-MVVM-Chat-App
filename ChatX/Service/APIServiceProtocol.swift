//
//  APIServiceProtocol.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/12.
//

import RxSwift

protocol APIServiceProtocol {
        
    func fetchUser(uid: String) -> Observable<User?>
    
    func fetchUsers() -> Observable<[User]>
    
    func fetchConversations() -> Observable<[Conversation]>
    
    func fetchMessages(forUser user: User) -> Observable<[Message]>
    
    func uploadMessage(_ message: String, To user: User?) -> Observable<Bool>
}
