//
//  FriendRepository.swift
//  SimpleChat
//
//  Created by 엄태양 on 2023/01/18.
//

import Foundation
import RxSwift

class FriendRepository {
    let network = FriendNetwork()
    
    func getAllUser() -> Observable<[User]> {
        return network.requestUserList()
    }
    
    func getFriends() -> Observable<[User]> {
        return network.requestFriendList()
    }
    
    func searchById(_ id: String) -> Observable<[User]> {
        return network.requestUserList()
            .map { $0.filter{ $0.uid.lowercased().contains(id.lowercased()) } }
    }
}
