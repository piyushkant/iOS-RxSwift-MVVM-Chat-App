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

typealias UserValues = (profileImage: UIImage?, email: String, fullName: String, userName: String, password: String)

final class AuthService {
    
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
    
    func signup(values: UserValues) -> Observable<Bool> {
        Observable.create { (observer) -> Disposable in
            Auth.auth().createUser(withEmail: values.email, password: values.password) { (result, error) in
                if let error = error {
                    print("failed to create User: ", error)
                    observer.onNext(false)
                    return
                }
                self.saveImageToFirebase(values: values)
                    .subscribe(onNext: {
                        observer.onNext($0)
                    })
                    .disposed(by: self.disposeBag)
            }
            
            return Disposables.create()
        }
    }
    
    private func saveImageToFirebase(values: UserValues) -> Observable<Bool> {
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        let imageData = values.profileImage?.jpegData(compressionQuality: 0.75) ?? Data()
        
        return Observable.create { (observer) -> Disposable in
            ref.putData(imageData, metadata: nil) { (_, error) in
                if let error = error {
                    print("failed to save image to firestore: ", error)
                    observer.onNext(false)
                    return
                }
                
                ref.downloadURL { (url, error) in
                    if let error = error {
                        print("failed to download image URL: ", error)
                        observer.onNext(false)
                        return
                    }
                    let imageURL = url?.absoluteString ?? ""
                    self.saveInfoToFirestore(values: values, imageURL: imageURL)
                        .subscribe(onNext: {
                            observer.onNext($0)
                        })
                        .disposed(by: self.disposeBag)
                }
            }
            return Disposables.create()
        }
    }
    
    private func saveInfoToFirestore(values: UserValues, imageURL: String) -> Observable<Bool> {
        let uid = Auth.auth().currentUser?.uid ?? ""
        
        let userData:[String: Any] = [
            "email": values.email,
            "fullname": values.fullName,
            "profileImageURL": imageURL,
            "uid": uid,
            "username": values.userName.lowercased()
        ]
        return Observable<Bool>.create { (observer) -> Disposable in
            Firestore.firestore().collection("users").document(uid).setData(userData) { (error) in
                if let error = error {
                    print("failed to save user Info: ", error)
                    observer.onNext(false)
                    return
                }
                observer.onNext(true)
            }
            return Disposables.create()
        }
    }
}
