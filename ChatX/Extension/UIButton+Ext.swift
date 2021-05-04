//
//  UIButton+Ext.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/04.
//

import UIKit

extension UIButton {
    func setBordersSettings() {
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = UIColor(hexString: "#4970bf").cgColor
        self.layer.masksToBounds = true
    }
}

extension UITextField {
    func setBordersSettings() {
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = UIColor(hexString: "#4970bf").cgColor
        self.layer.masksToBounds = true
    }
}
