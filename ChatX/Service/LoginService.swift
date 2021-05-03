//
//  LoginService.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/03.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase
import FirebaseFirestore

final class LoginService {
    
    init() { }
    
    var disposeBag = DisposeBag()
    
    func login(email: String, password: String) -> Observable<Bool> {
        Observable.create {(observer) -> Disposable in
            Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(true)
                }
            }
            
            return Disposables.create {
                observer.onCompleted()
            }
        }
    }
    
    func signup() {
        
    }
}
