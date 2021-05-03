//
//  Message.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/03.
//

import Foundation
import Firebase

struct Message {
    var text: String
    let toId: String
    let fromId: String
    var timestamp: Timestamp!
    var user: User?
    
    var isFromCurrentUser: Bool
    
    init(dic: [String: Any]) {
        self.text = dic["text"] as? String ?? ""
        self.toId = dic["toId"] as? String ?? ""
        self.fromId = dic["fromId"] as? String ?? ""
        self.timestamp = dic["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        
        self.isFromCurrentUser = fromId == Auth.auth().currentUser?.uid
    }
    
    init(original: Message, user: User) {
        self = original
        self.user = user
    }
}
