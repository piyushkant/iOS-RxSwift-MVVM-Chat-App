//
//  LoginViewModelBindable.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/04.
//

import UIKit
import RxSwift
import RxCocoa

protocol LoginViewModelBindable {
    // Input
    var email: BehaviorRelay<String> { get }
    var password: BehaviorRelay<String> { get }
    var loginButtonTapped: PublishRelay<Void> { get }
    
    // Output
    var isLoginCompleted: Signal<LoginResult> { get }
    var isFormValid: Driver<Bool> { get }
}
