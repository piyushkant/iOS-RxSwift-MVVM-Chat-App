//
//  UIViewController+Ext.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/03.
//

import UIKit
import Firebase
import FirebaseAuth
import JGProgressHUD
import RxSwift
import RxCocoa

extension UIViewController {
    static let hud = JGProgressHUD(style: .dark)
    
    func showActivityIndicator(_ show: Bool, withText text: String? = "Loading") {
        view.endEditing(true)
        UIViewController.hud.textLabel.text = text
        
        if show {
            UIViewController.hud.show(in: view)
        } else {
            UIViewController.hud.dismiss()
        }
    }
}
