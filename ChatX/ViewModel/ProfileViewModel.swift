//
//  ProfileViewModel.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/04.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase

struct ProfileViewModel: ProfileViewModelBindable {
    // Output
    var user: Driver<User?>
    
    init(service: APIService = .shared) {
        let uid = Auth.auth().currentUser?.uid
        user = service.fetchUser(uid: uid ?? "")
            .retry(2)
            .asDriver(onErrorJustReturn: nil)
    }
}
