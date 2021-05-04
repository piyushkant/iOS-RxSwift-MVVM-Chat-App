//
//  ChatViewModel.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/04.
//

import Foundation
import RxSwift
import RxCocoa

struct ChatViewModel: ChatViewModelBindable {
    // Input
    let userData = BehaviorRelay<User?>(value: nil)
    let inputText = BehaviorRelay<String>(value: "")
    let sendButtonTapped = PublishSubject<Void>()
    
    // Output
    let isMessageUploaded: Driver<Bool>
    let messages = BehaviorRelay<[Message]>(value: [])
    
    var disposeBag = DisposeBag()
    
    init(user: User, service: APIService = .shared) {
        self.userData.accept(user)
        
        let didNewMessageIncome = PublishRelay<Void>()
        let fetchedMessages = service
            .fetchMessages(forUser: user)
            .share()
        
        fetchedMessages
            .catchAndReturn([])
            .bind(to: messages)
            .disposed(by: disposeBag)
        
        fetchedMessages
            .mapToVoid()
            .bind(to: didNewMessageIncome)
            .disposed(by: disposeBag)
        
        didNewMessageIncome
            .skip(1)
            .subscribe(onNext: { _ in
                NotificationCenter.default.post(name: Notifications.didFinishFetchMessage, object: nil)
            })
            .disposed(by: disposeBag)
        
        let source = Observable
            .combineLatest(
                inputText,
                userData
            )
        
        isMessageUploaded = sendButtonTapped
            .withLatestFrom(source)
            .filter{ $0.0 != ""}
            .flatMapLatest{
                service.uploadMessage($0.0, To: $0.1)
            }
            .asDriver(onErrorJustReturn: false)
    }
}
