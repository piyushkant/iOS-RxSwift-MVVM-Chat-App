//
//  Utils.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/03.
//

import Foundation

class Utils {
    
    static func isValidEmailAddress(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
