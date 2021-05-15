//
//  SignupViewModelBindable.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/04.
//

import UIKit
import RxSwift
import RxCocoa

protocol SignupViewModelModeling {
    
    // MARK: - Input
    var profileImage: PublishRelay<UIImage?> { get }
    var email: PublishRelay<String> { get }
    var fullName: PublishRelay<String> { get }
    var userName: PublishRelay<String> { get }
    var password: PublishRelay<String> { get }
    var signupButtonTapped: PublishRelay<Void> { get }
    
    // MARK: - Output
    var isRegistering: Driver<Bool> { get }
    var isRegistered: Signal<LoginResult> { get }
    var isFormValid: Driver<Bool> { get }
}
