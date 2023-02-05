//
//  ChatNetwork.swift
//  SimpleChat
//
//  Created by 엄태양 on 2023/02/04.
//

import Foundation
import RxSwift
import RxRelay
import FirebaseDatabase
import FirebaseAuth

struct ChatNetwork {
    
    func requestCreateChat(_ msg: Message) -> Observable<RequestResult> {
        return Observable.create { observer in
            if let uid = Auth.auth().currentUser?.uid {
                Database.database().reference().child("chats/\(uid)/\(msg.to)").getData { error, snapshot in
                    if error != nil {
                        observer.onNext(RequestResult(isSuccess: false, msg: "오류가 발생하였습니다.\n 잠시후에 다시 시도해주세요."))
                    } else {
                        Database.database().reference().child("chats/\(uid)/\(msg.to)").childByAutoId().setValue(msg.toDictionary) { error, _ in
                            if error != nil {
                                observer.onNext(RequestResult(isSuccess: false, msg: "오류가 발생하였습니다.\n 잠시후에 다시 시도해주세요."))
                            }
                        }
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
    func addListener(from: User, to: User) -> Observable<[Message]> {
        return Observable<[Message]>.create { observer in
            Database.database().reference().child("chats/\(from.uid)/\(to.uid)").observe(.value) { snapshot  in
                if let value = snapshot.value {
                    let value = value as? [String: [String:String]] ?? [:]
                    let newList = value.values.map { Message(to: $0["to"]!, from: $0["from"]!, contents: $0["contents"]!, date: $0["date"]!) }
                    
                    observer.onNext(newList.sorted { $0.date < $1.date })
                    
                }
                
                
            }
            return Disposables.create()
        }
        
    }
}
