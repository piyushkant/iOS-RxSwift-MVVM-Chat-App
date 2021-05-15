//
//  ChatViewModelBindable.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/04.
//

import UIKit
import RxSwift
import RxCocoa

protocol ChatViewModelModeling {
    
    // MARK: - Input
    var userData: BehaviorRelay<User?> { get }
    var inputText: BehaviorRelay<String> { get }
    var sendButtonTapped: PublishSubject<Void> { get }
    
    // MARK: - Output
    var isMessageUploaded: Driver<Bool> { get }
    var messages: BehaviorRelay<[Message]> { get }
}
