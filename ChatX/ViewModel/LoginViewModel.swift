//
//  LoginViewModel.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/03.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase

struct LoginViewModel: LoginViewModelModeling {
    
    // MARK: - Input
    let email = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    let loginButtonTapped = PublishRelay<Void>()
    
    // MARK: - Output
    let isLoginCompleted: Signal<LoginResult>
    let isFormValid: Driver<Bool>
    
    init(service: AuthService = AuthService()) {
        self.isFormValid = Observable
            .combineLatest(
                email,
                password
            )
            .map { 
                Utils.isValidEmailAddress(email: $0)
                    && $1.count > 6
            }
            .asDriver(onErrorJustReturn: false)
        
        self.isLoginCompleted = self.loginButtonTapped
            .withLatestFrom(
                Observable.combineLatest(self.email, self.password)
            )
            .flatMapLatest {
                service.login(email: $0, password: $1)
            }
            .asSignal(onErrorJustReturn: .failure("Server error"))
    }
}
