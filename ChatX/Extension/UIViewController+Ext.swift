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
    
    func logoutCurrentUser(completion: (Error?) -> Void) {
        do{
            try Auth.auth().signOut()
            completion(nil)
        } catch {
            print(error)
            completion(error)
        }
    }
    
    func setupNavigationBar(with title: String, prefersLargeTitles: Bool) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = #colorLiteral(red: 0, green: 0.7599403262, blue: 0.9988735318, alpha: 1)
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
        navigationItem.title = title
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
    }
    
    func switchToLoginVC() {
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                window.backgroundColor = .systemBackground
                let loginVC = LoginViewController.create(with: LoginViewModel())
                let rootVC = UINavigationController(rootViewController: loginVC)
                window.rootViewController = rootVC
                
                let sceneDelegate = windowScene.delegate as? SceneDelegate
                sceneDelegate?.window = window
                window.makeKeyAndVisible()
            }
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.backgroundColor = .systemBackground
            let loginVC = LoginViewController.create(with: LoginViewModel())
            let rootVC = UINavigationController(rootViewController: loginVC)
            window.rootViewController = UINavigationController(rootViewController: rootVC)
            window.makeKeyAndVisible()
            appDelegate.window = window
        }
    }
    
    func switchToChatListVC() {
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                window.backgroundColor = .systemBackground
                let chatListVC = ChatListViewController.create(with: ChatListViewModel())
                let rootVC = UINavigationController(rootViewController: chatListVC)
                window.rootViewController = rootVC
                
                let sceneDelegate = windowScene.delegate as? SceneDelegate
                window.makeKeyAndVisible()
                sceneDelegate?.window = window
            }
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.backgroundColor = .systemBackground
            let chatListVC = ChatListViewController.create(with: ChatListViewModel())
            let rootVC = UINavigationController(rootViewController: chatListVC)
            window.rootViewController = rootVC
            window.makeKeyAndVisible()
            appDelegate.window = window
        }
    }
    
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
    
    var topbarHeight: CGFloat {
        let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        return statusBarHeight +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
}
