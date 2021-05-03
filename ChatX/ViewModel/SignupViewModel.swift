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

struct SignupViewModel: SignupViewModelBindable {
    
    // MARK: - Properties
    let profileImage = PublishRelay<UIImage?>()
    let email = PublishRelay<String>()
    let fullName = PublishRelay<String>()
    let userName = PublishRelay<String>()
    let password = PublishRelay<String>()
    let signupButtonTapped = PublishRelay<Void>()
    
    let isRegistering: Driver<Bool>
    let isRegistered: Signal<Bool>
    let isFormValid: Driver<Bool>
    
    var disposeBag = DisposeBag()
    
    // MARK: - Initializer
    init(service: AuthService = AuthService()) {
        
        let onRegistering = PublishRelay<Bool>()
        isRegistering = onRegistering.asDriver(onErrorJustReturn: false)
        let onRegistered = PublishRelay<Bool>()
        isRegistered = onRegistered.asSignal(onErrorJustReturn: false)
        
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
