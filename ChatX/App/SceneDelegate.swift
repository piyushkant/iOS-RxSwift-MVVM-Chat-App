//
//  SceneDelegate.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/03.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        isLoggedIn() ? self.openChatListVC() : self.openLoginVC(windowScene: windowScene)
    }
    
    func openLoginVC(windowScene: UIWindowScene) {
        window = UIWindow(windowScene: windowScene)
        let loginViewController = LoginViewController.create(with: LoginViewModel())
        window?.rootViewController = UINavigationController(rootViewController: loginViewController)
        window?.makeKeyAndVisible()
    }
    
    func openChatListVC() {
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
    }
    
    func isLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
}

