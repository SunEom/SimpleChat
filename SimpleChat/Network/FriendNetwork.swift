//
//  FriendNetwork.swift
//  SimpleChat
//
//  Created by 엄태양 on 2023/01/18.
//

import Foundation
import FirebaseDatabase
import RxSwift
import FirebaseAuth

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
                    User(uid: uid)
                })
            });
            
            return Disposables.create()
        }
    }
    
    func requestFriendList() -> Observable<[User]> {
        return Observable.create { observer in
            if let uid = Auth.auth().currentUser?.uid {
                Database.database().reference().child("friends/\(uid)").getData(completion: { error, snapshot in
                    guard error == nil else {
                      print(error!.localizedDescription)
                        observer.onNext([User]())
                        return
                    }
                    
                    var data = snapshot.value! as? [String: Int] ?? [:]
                    data = data.filter { $0.value == 1 }

                    
                    observer.onNext(data.map { User(uid: $0.key) })
                });
            }
            return Disposables.create()
        }
    }
    
}
