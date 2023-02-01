//
//  ChatRoomViewModel.swift
//  SimpleChat
//
//  Created by 엄태양 on 2023/02/01.
//

import Foundation
import RxRelay
import RxSwift

struct ChatRoomViewModel {
    let disposeBag = DisposeBag()
    let chatWith: Observable<User>
    
    init(friend: User) {
        chatWith = Observable.just(friend)
    }
}
