//
//  Reactive+Ext.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/03.
//

import UIKit
import Firebase
import FirebaseAuth
import JGProgressHUD
import RxSwift
import RxCocoa


// MARK: - Reactive Custom Binder
extension Reactive where Base: SignupViewController {
    var setProfileImage: Binder<UIImage?> {
        return Binder(base) { base, image in
            base.addPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            base.addPhotoButton.layer.cornerRadius = base.addPhotoButton.frame.width / 2
            base.addPhotoButton.layer.borderWidth = 3
            base.addPhotoButton.layer.borderColor = UIColor.white.cgColor
        }
    }
}

extension Reactive where Base: UIRefreshControl {
    var spinner: Binder<Bool> {
        return Binder(base) { (refreshControl, isRefresh) in
            if isRefresh {
                refreshControl.beginRefreshing()
            } else {
                refreshControl.endRefreshing()
            }
        }
    }
}

extension ObservableType {
    
    func catchErrorJustComplete() -> Observable<Element> {
        return catchError { _ in
            return Observable.empty()
        }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            return Driver.empty()
        }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
