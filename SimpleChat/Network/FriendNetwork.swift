//
//  FriendNetwork.swift
//  SimpleChat
//
//  Created by 엄태양 on 2023/01/18.
//

import Foundation
import FirebaseDatabase
import RxSwift

struct FriendNetwork {
    func requestUserList() -> Observable<[User]> {
        return Observable.create { observer in
            Database.database().reference().child("users").getData(completion: { error, snapshot in
                guard error == nil else {
                  print(error!.localizedDescription)
                    observer.onNext([User]())
                    return
                }
                let values = snapshot.value as? [String: String] ?? [:]
                observer.onNext(values.map{ uid, nickname in
                    User(nickname: nickname, uid: uid)
                })
            });
            
            return Disposables.create()
        }
    }
}
