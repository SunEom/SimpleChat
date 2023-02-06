//
//  LoginViewModel.swift
//  SimpleChat
//
//  Created by 엄태양 on 2023/01/10.
//

import Foundation
import RxSwift
import RxRelay
import FirebaseAuth

class LoginViewModel {
    
    let disposeBag = DisposeBag()
    let emailData = BehaviorRelay(value: "")
    let pwdData = BehaviorRelay(value: "")
    let loginBtnTap = PublishRelay<Void>()
    let loginCheckRequest = PublishSubject<Void>()
    let loginResult = PublishSubject<RequestResult>()

    init(_ repo: UserRepository = UserRepository()) {
        loginBtnTap
            .withLatestFrom(Observable.combineLatest(self.emailData, self.pwdData))
            .map { repo.login(email: $0, pwd: $1 )}
            .flatMapLatest{ $0 }
            .bind(to: loginResult)
            .disposed(by: disposeBag)
        
        loginCheckRequest
            .map { Auth.auth().currentUser != nil ? true : false }
            .filter { $0 }
            .map { islogined in
                return RequestResult(isSuccess: islogined, msg: "")
            }
            .bind(to: loginResult)
            .disposed(by: disposeBag)
    }
    
}
