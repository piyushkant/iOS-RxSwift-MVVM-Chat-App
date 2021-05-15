//
//  EndPoint.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/15.
//

import Foundation

enum EndPoint {
    static let baseURL = URL(string: "https://fcm.googleapis.com/fcm/")!
    
    case send
    
    var url: URL {
        switch self {
        case .send:
            return EndPoint.baseURL.appendingPathComponent("send")
        }
    }
}

