//
//  BubbleViewModel.swift
//  SimpleChat
//
//  Created by 엄태양 on 2023/02/02.
//

import Foundation
import RxSwift
import RxRelay
import FirebaseAuth

struct BubbleViewModel {
    let isMine: Observable<Bool>
    let contents: Observable<String>
    
    init(_ msg: Message){
        contents = Observable.just(msg.contents)
        isMine = Observable.just(msg.from == Auth.auth().currentUser?.uid)
    }
}
