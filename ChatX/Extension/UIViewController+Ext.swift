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
    
    func didTapAddPhotoButton<T: UIImagePickerControllerDelegate & UINavigationControllerDelegate>(viewController: T) {
        self.view.endEditing(true)
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = viewController
        let alert = UIAlertController(title: "Select ImageSource", message: "", preferredStyle: .alert)
        
        let takePhoto = UIAlertAction(title: "Take photo", style: .default) { (_) in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
            imagePicker.sourceType = .camera
            imagePicker.videoQuality = .typeHigh
            self.present(imagePicker, animated: true)
        }
        
        let album = UIAlertAction(title: "Photo Album", style: .default) { (_) in
            imagePicker.sourceType = .savedPhotosAlbum
            self.present(imagePicker, animated: true)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(takePhoto)
        alert.addAction(album)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
}