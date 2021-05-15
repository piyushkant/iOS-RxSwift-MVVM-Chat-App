//
//  PropertyUtils.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/15.
//

import Foundation

public struct PropertyUtils {
    public static func getValue(fileName: String, key: String) -> String {
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: "plist") else {
            fatalError("Couldn't find file '\(fileName).plist'.")
        }
        
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: key) as? String else {
            fatalError("Couldn't find key '\(key)' in '\(fileName).plist'.")
        }
        
        return value
    }
}

