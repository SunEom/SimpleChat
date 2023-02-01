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
    
    init(_ repo: FriendRepository = FriendRepository()) {
        repo.getFriends()
            .bind(to: friends)
            .disposed(by: disposeBag)
    }
}
