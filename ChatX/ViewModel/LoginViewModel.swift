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

struct LoginViewModel: LoginViewModelBindable {
    
    let email = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    let loginButtonTapped = PublishRelay<Void>()
    
    let isLoginCompleted: Signal<Bool>
    let isValidForm: Driver<Bool>
    
    init(service: AuthService = AuthService()) {
        self.isValidForm = Observable
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
            .asSignal(onErrorJustReturn: false)
    }
}
