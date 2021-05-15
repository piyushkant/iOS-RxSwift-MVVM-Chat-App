//
//  SignupViewModel.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/03.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase

typealias UserValues = (profileImage: UIImage?, email: String, fullName: String, userName: String, password: String)

struct SignupViewModel: SignupViewModelModeling {
    
    // MARK: - Input
    let profileImage = PublishRelay<UIImage?>()
    let email = PublishRelay<String>()
    let fullName = PublishRelay<String>()
    let userName = PublishRelay<String>()
    let password = PublishRelay<String>()
    
    let signupButtonTapped = PublishRelay<Void>()
    
    // MARK: - Output
    let isRegistering: Driver<Bool>
    let isRegistered: Signal<LoginResult>
    let isFormValid: Driver<Bool>
    
    var disposeBag = DisposeBag()
    
    init(service: AuthService = AuthService()) {
        
        let onRegistering = PublishRelay<Bool>()
        isRegistering = onRegistering.asDriver(onErrorJustReturn: false)
        let onRegistered = PublishRelay<LoginResult>()
        isRegistered = onRegistered.asSignal(onErrorJustReturn: .failure("Server error"))
        
        let registrationValues = Observable
            .combineLatest(
                profileImage,
                email,
                fullName,
                userName,
                password
            )
            .share()
        
        isFormValid = registrationValues
            .map {
                 $0 != nil
                    && Utils.isValidEmailAddress(email: $1)
                    && $2.count > 2
                    && $3.count > 2
                    && $4.count > 6
                
            }
            .asDriver(onErrorJustReturn: false)
        
        signupButtonTapped
            .withLatestFrom(
                registrationValues
            )
            .do(onNext:{ _ in
                onRegistering.accept(true)
            })
            .flatMapLatest( service.signup )
            .subscribe(onNext: {
                onRegistering.accept(false)
                onRegistered.accept($0)
            })
            .disposed(by: disposeBag)
    }
}
