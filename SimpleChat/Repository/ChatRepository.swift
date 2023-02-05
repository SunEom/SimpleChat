//
//  ChatRepository.swift
//  SimpleChat
//
//  Created by 엄태양 on 2023/02/04.
//

import Foundation
import RxSwift
import RxRelay

struct ChatRepository {
    let network = ChatNetwork()
    let disposeBag = DisposeBag()
    
    func initChatList(from: User, to: User) -> Observable<[Message]> {
        return network.addListener(from: from, to: to)
    }
    
    func newChats(_ msg: Message) -> Observable<RequestResult> {
        return network.requestCreateChat(msg)
    }
}
