//
//  SceneDelegate.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/03.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
//                let loginViewController = LoginViewController.create(with: LoginViewModel())
//                let loginViewController = SignupViewController.create(with: SignupViewModel())
        let loginViewController = ChatListViewController.create(with: ChatListViewModel())
        window?.rootViewController = UINavigationController(rootViewController: loginViewController)
        window?.makeKeyAndVisible()
    }
}

