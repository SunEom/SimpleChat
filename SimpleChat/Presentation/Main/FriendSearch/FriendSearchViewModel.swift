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
    
    init(_ repo : FriendRepository = FriendRepository()) {
        searchBtnTap
            .withLatestFrom(keyword)
            .flatMapLatest { repo.searchById($0) }
            .bind(to: list)
            .disposed(by: disposeBag)
    }
}
