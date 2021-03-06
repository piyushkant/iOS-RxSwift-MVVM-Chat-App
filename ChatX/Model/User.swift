//
//  User.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/03.
//

import Foundation

struct User {
    let email: String
    let fullname: String
    var profileImageUrl: String
    let uid: String
    var username: String
    
    init?(user: [String: Any]) {
        guard let email = user["email"] as? String else { return nil }
        self.email = email
        
        guard let fullname = user["fullname"] as? String else { return nil }
        self.fullname = fullname
        
        guard let profileImageUrl = user["profileImageURL"] as? String else { return nil }
        self.profileImageUrl = profileImageUrl
        
        guard let uid = user["uid"] as? String else { return nil }
        self.uid = uid
        
        guard let username = user["username"] as? String else { return nil }
        self.username = username
    }
}
