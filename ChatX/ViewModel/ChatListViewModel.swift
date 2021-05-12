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
    //Input
    let filterKey = PublishRelay<String>()
    let searchCancelButtonTapped = PublishRelay<Void>()
    
    //Output
    let conversations = BehaviorRelay<[Conversation]>(value: [])
    
    var disposeBag = DisposeBag()
    
    init(service: APIServiceProtocol = APIService.shared) {
        let baseCoversationsForFiltering = PublishRelay<[Conversation]>()
        
        let fetchedConversations = service.fetchConversations()
            .retry(2)
            .catchAndReturn([])
            .share()
        
        fetchedConversations
            .bind(to: conversations)
            .disposed(by: disposeBag)
        
        fetchedConversations
            .bind(to: baseCoversationsForFiltering)
            .disposed(by: disposeBag)
        
        let reFetchedConversations = Observable
            .merge(
                searchCancelButtonTapped.asObservable()
            )
            .flatMapLatest(service.fetchConversations)
            .catchAndReturn([])
            .share()
        
        reFetchedConversations
            .bind(to: conversations)
            .disposed(by: disposeBag)
        
        // Keyword for searching
        let inputText = filterKey
            .distinctUntilChanged()
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map{ $0.lowercased() }
            .share()
        
        Observable.combineLatest(
            inputText,
            baseCoversationsForFiltering
        )
        .filter { $0.0 != ""}
        .map{ text, conversations -> [Conversation] in
            //            onSearching.accept(true)
            return conversations.filter{
                $0.user.username.lowercased().contains(text)
            }
        }
        .bind(to: conversations)
        .disposed(by: disposeBag)
    }
}
