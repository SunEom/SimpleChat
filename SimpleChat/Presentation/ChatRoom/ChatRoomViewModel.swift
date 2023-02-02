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
    let chats = PublishSubject<[Message]>.just([
        Message(uid: "ZaIbLsXpC3fkc3Ex10kY7ur1xbI3", contents: "askjdh flaksjhdflakjs dhflaksjd hflaksjd flhaksjd fhlaksjd fhlaksjd fhlaksjdh flasd", date: Date()),
        Message(uid: "asdf", contents: "askjdh flaksjhdflakjs dhflaksjd hflaksjd flhaksjd fhlaksjd fhlaksjd fhlaksjdh flasd", date: Date()),
        Message(uid: "asdf", contents: "askjdh flaksjhdflakjs dhflaksjd hflaksjd flhaksjd fhlaksjd fhlaksjd fhlaksjdh flasd", date: Date()),
        Message(uid: "ZaIbLsXpC3fkc3Ex10kY7ur1xbI3", contents: "askjdh flaksjhdflakjs dhflaksjd hflaksjd flhaksjd fhlaksjd fhlaksjd fhlaksjdh flasd", date: Date()),
        Message(uid: "asdf", contents: "askjdh flaksjhdflakjs dhflaksjd hflaksjd flhaksjd fhlaksjd fhlaksjd fhlaksjdh flasd", date: Date()),
        Message(uid: "asdf", contents: "askjdh flaksjhdflakjs dhflaksjd hflaksjd flhaksjd fhlaksjd fhlaksjd fhlaksjdh flasd", date: Date()),
        Message(uid: "ZaIbLsXpC3fkc3Ex10kY7ur1xbI3", contents: "askjdh flaksjhdflakjs dhflaksjd hflaksjd flhaksjd fhlaksjd fhlaksjd fhlaksjdh flasd", date: Date()),
        Message(uid: "asdf", contents: "askjdh flaksjhdflakjs dhflaksjd hflaksjd flhaksjd fhlaksjd fhlaksjd fhlaksjdh flasd", date: Date()),
        Message(uid: "asdf", contents: "askjdh flaksjhdflakjs dhflaksjd hflaksjd flhaksjd fhlaksjd fhlaksjd fhlaksjdh flasd", date: Date())
    ])
    
    init(friend: User) {
        chatWith = Observable.just(friend)
    }
}
