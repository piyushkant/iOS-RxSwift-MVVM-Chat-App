//
//  ChatListViewModel.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/04.
//

import Foundation
import RxSwift
import RxCocoa

struct ChatListViewModel: ChatListViewModelBindable {
    //Output
    let conversations = BehaviorRelay<[Conversation]>(value: [])
    
    var disposeBag = DisposeBag()
    
    init(service: APIService = .shared) {
        service.fetchConversations()
            .retry(2)
            .catchAndReturn([])
            .bind(to: conversations)
            .disposed(by: disposeBag)
    }
}
