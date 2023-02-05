//
//  ChatRoomViewModel.swift
//  SimpleChat
//
//  Created by 엄태양 on 2023/02/01.
//

import Foundation
import RxRelay
import RxSwift
import FirebaseAuth

class ChatRoomViewModel {
    let disposeBag = DisposeBag()
    let chatWith: Observable<User>
    let chats = BehaviorSubject<[Message]>(value: [])
    let myChats = BehaviorSubject<[Message]>(value: [])
    let othersChats = BehaviorSubject<[Message]>(value: [])
    let newChats = PublishSubject<Message>()
    let newChatRequestResult = PublishSubject<RequestResult>()
    
    init(friend: User, _ repo: ChatRepository = ChatRepository()) {
        chatWith = Observable.just(friend)
        
        repo.initChatList(from: User(uid: Auth.auth().currentUser?.uid ?? ""), to: friend )
            .bind(to: myChats)
            .disposed(by: disposeBag)
        repo.initChatList(from: friend, to: User(uid: Auth.auth().currentUser?.uid ?? "") )
            .bind(to: othersChats)
            .disposed(by: disposeBag)
        
        
        Observable.combineLatest(myChats, othersChats)
            .map { ($0+$1).sorted { $0.date < $1.date } }
            .bind(to: chats)
            .disposed(by: disposeBag)
            
        newChats
            .flatMapLatest { repo.newChats($0) }
            .bind(to: newChatRequestResult)
            .disposed(by: disposeBag)
        
    }
}
