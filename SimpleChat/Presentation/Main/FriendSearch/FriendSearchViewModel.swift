//
//  FriendSearchViewModel.swift
//  SimpleChat
//
//  Created by 엄태양 on 2023/01/18.
//

import Foundation
import RxSwift
import RxRelay
import FirebaseDatabase

class FriendSearchViewModel {
    
    let disposeBag = DisposeBag()
    let keyword = BehaviorRelay(value: "")
    let searchBtnTap = PublishRelay<Void>()
    let list = BehaviorSubject(value: [User]())
    let newFriend = PublishSubject<User>()
    let AddFriendRequestResult = PublishSubject<RequestResult>()
    
    init(_ repo : FriendRepository = FriendRepository()) {
        searchBtnTap
            .withLatestFrom(keyword)
            .flatMapLatest { repo.searchById($0) }
            .bind(to: list)
            .disposed(by: disposeBag)
        
        newFriend
            .flatMapLatest { repo.addNewFriend(fuid: $0.uid)}
            .bind(to: AddFriendRequestResult)
            .disposed(by: disposeBag)
            
    }
}
