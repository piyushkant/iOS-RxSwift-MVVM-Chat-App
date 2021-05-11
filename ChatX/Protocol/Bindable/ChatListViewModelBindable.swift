//
//  ChatListModelBindable.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/04.
//

import UIKit
import RxSwift
import RxCocoa

protocol ChatListViewModelBindable: ViewModelType {
    // Input -> ViewModel
    var filterKey: PublishRelay<String> { get }
    var searchCancelButtonTapped: PublishRelay<Void> { get }
    
    //Output
    var conversations: BehaviorRelay<[Conversation]> { get }
}
