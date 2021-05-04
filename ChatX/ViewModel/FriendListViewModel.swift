//
//  FriendListViewModel.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/04.
//

import Foundation
import RxSwift
import RxCocoa

struct FriendListViewModel: FriendListViewModelBindable {
    // Input
    let refreshPulled: PublishRelay<Void>
    let filterKey = PublishRelay<String>()
    let searchCancelButtonTapped = PublishRelay<Void>()
    
    // Output
    var users = BehaviorRelay<[User]>(value: [])
    let isNetworking: Driver<Bool>
    
    var disposeBag = DisposeBag()
    
    init(service: APIService = .shared) {
        
        // Proxy
        let onRefreshPulled = PublishRelay<Void>()
        refreshPulled = onRefreshPulled
        
        let onNetworking = PublishRelay<Bool>()
        isNetworking = onNetworking.asDriver(onErrorJustReturn: false)
        
        // Material
        let baseUsersForFiltering = PublishRelay<[User]>()
        let onSearching = BehaviorRelay<Bool>(value: false)
        
        // ReFetching by refreshing and canceling search
        let refreshing = Observable
            .combineLatest(
                refreshPulled,
                onSearching
            )
            .filter{ !$1 }
            .mapToVoid()
        
        // Initial Fetching
        let fetchedUsers = service
            .fetchUsers()
            .retry{ _ in onRefreshPulled }
            .share()
        
        fetchedUsers
            .bind(to: users)
            .disposed(by: disposeBag)
        
        fetchedUsers
            .bind(to: baseUsersForFiltering)
            .disposed(by: disposeBag)
        
        let reFetchedUsers = Observable
            .merge(
                refreshing,
                searchCancelButtonTapped.asObservable()
            )
            .do(onNext: { onNetworking.accept(true) })
            .flatMapLatest(service.fetchUsers)
            .catchAndReturn([])
            .share()
        
        reFetchedUsers
            .map{ _ in false }
            .bind(to: onNetworking)
            .disposed(by: disposeBag)
        
        reFetchedUsers
            .bind(to: users)
            .disposed(by: disposeBag)
        
        // Keyword for searching
        let inputText = filterKey
            .distinctUntilChanged()
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map{ $0.lowercased() }
            .share()
        
        Observable.combineLatest(
            inputText,
            baseUsersForFiltering
        )
        .filter { $0.0 != ""}
        .map{ text, users -> [User] in
            onSearching.accept(true)
            return users.filter{ $0.fullname.lowercased().contains(text)
                || $0.username.lowercased().contains(text)}
        }
        .bind(to: users)
        .disposed(by: disposeBag)
        
        inputText
            .filter{ $0 == "" }
            .do(onNext: { _ in onSearching.accept(false) })
            .map { _ in Void()}
            .flatMapLatest(service.fetchUsers)
            .bind(to: users)
            .disposed(by: disposeBag)
    }
}
