//
//  FriendListViewModel.swift
//  SimpleChat
//
//  Created by 엄태양 on 2023/01/17.
//

import Foundation
import RxSwift
import RxRelay

class FriendListViewModel {
    let disposeBag = DisposeBag()
    let friends = BehaviorSubject(value: [User]())
    let selectedIdx = PublishSubject<Int>()
    let selectedFriend = PublishSubject<User>()
    let listRefresh = PublishSubject<Void>()
    let deleteFriend = PublishSubject<User>()
    let deleteFriendResult = PublishSubject<RequestResult>()
    
    init(_ repo: FriendRepository = FriendRepository()) {
        
        listRefresh.subscribe(onNext: {
            repo.getFriends()
                .map { $0.sorted { $0.uid < $1.uid }}
                .bind(to: self.friends)
                .disposed(by: self.disposeBag)
        })
        .disposed(by: disposeBag)
        
        deleteFriend
            .flatMapLatest { repo.deleteFriend($0) }
            .bind(to: deleteFriendResult)
            .disposed(by: disposeBag)
        
        deleteFriendResult
            .map { _ in Void() }
            .bind(to: listRefresh)
            .disposed(by: disposeBag)
        
    }
}
