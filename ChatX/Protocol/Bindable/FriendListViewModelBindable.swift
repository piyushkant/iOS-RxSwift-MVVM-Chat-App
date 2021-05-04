//
//  FriendListViewModelBindable.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/04.
//

import UIKit
import RxSwift
import RxCocoa

protocol FriendListViewModelBindable: ViewModelType {
    // Input -> ViewModel
    var refreshPulled: PublishRelay<Void> { get }
    var filterKey: PublishRelay<String> { get }
    var searchCancelButtonTapped: PublishRelay<Void> { get }
    
    // ViewModel -> OutPut
    var users: BehaviorRelay<[User]> { get }
    var isNetworking: Driver<Bool> { get }
}
