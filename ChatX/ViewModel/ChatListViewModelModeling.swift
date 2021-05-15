//
//  ChatListModelBindable.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/04.
//

import UIKit
import RxSwift
import RxCocoa

protocol ChatListViewModelModeling {
    
    // MARK: - Input
    var filterKey: PublishRelay<String> { get }
    var searchCancelButtonTapped: PublishRelay<Void> { get }
    
    // MARK: - Output
    var conversations: BehaviorRelay<[Conversation]> { get }
}
