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
    let loginResult = PublishSubject<RequestResult>()

    init(_ repo: LoginRepository = LoginRepository()) {
        loginBtnTap
            .withLatestFrom(Observable.combineLatest(self.emailData, self.pwdData))
            .map { repo.loginRequest(email: $0, pwd: $1 )}
            .flatMapLatest{ $0 }
            .bind(to: loginResult)
            .disposed(by: disposeBag)
    }
    
}
