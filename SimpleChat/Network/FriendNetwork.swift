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
    
    func requestAddFriend(fuid: String) -> Observable<RequestResult> {
        return Observable.create { observer in
            if let uid = Auth.auth().currentUser?.uid {
                Database.database().reference().child("friends/\(uid)/\(fuid)").getData { error, snapshot in
                    if error != nil {
                        observer.onNext(RequestResult(isSuccess: false, msg: "요청에 실패했습니다.\n잠시후 다시 시도해주세요."))
                    } else {
                        
                        if snapshot.value as? Bool != nil && snapshot.value as! Bool == true {
                            observer.onNext(RequestResult(isSuccess: false, msg: "이미 추가된 친구입니다"))
                        } else {
                            Database.database().reference().child("friends/\(uid)/\(fuid)").setValue(true) { error, reference in
                                
                                if let error = error {
                                    observer.onNext(RequestResult(isSuccess: false, msg: error.localizedDescription))
                                } else {
                                    observer.onNext(RequestResult(isSuccess: true, msg: "정상적으로 추가되었습니다."))
                                }
                            }
                        }
                        
                    }
                }
                
            }
            return Disposables.create()
        }
    }
    
    func requestDeleteFriend(_ user: User) -> Observable<RequestResult> {
        return Observable.create { observer in
            if let uid = Auth.auth().currentUser?.uid {
                Database.database().reference().child("friends/\(uid)/\(user.uid)").removeValue { error, reference in
                    if let error = error {
                        observer.onNext(RequestResult(isSuccess: false, msg: error.localizedDescription))
                    } else {
                        observer.onNext(RequestResult(isSuccess: true, msg: "정상적으로 삭제되었습니다."))
                    }
                }
            }
            return Disposables.create()
        }
    }
    
}
