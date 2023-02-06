//
//  SignInViewModel.swift
//  SimpleChat
//
//  Created by 엄태양 on 2023/01/10.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class SignInViewModel {
    
    private let disposeBag = DisposeBag()
    
    let emailData = BehaviorRelay(value: "")
    let pwdData = BehaviorRelay(value: "")
    let checkData = BehaviorRelay(value: "")
    let loading = BehaviorSubject(value: false)
    
    let saveBtnTap = PublishRelay<Void>()
    
    let requestResult = PublishSubject<RequestResult>()
    
    init(_ repo: AccountRepository = AccountRepository()) {
        saveBtnTap
            .map { self.loading.onNext(true) }
            .withLatestFrom(Observable.combineLatest(emailData, pwdData, checkData))
            .map { (email, pwd, check) in
                return repo.requestSignIn(email, pwd, check)
            }
            .map {
                self.loading.onNext(false)
                return $0
            }
            .flatMapLatest{ $0 }
            .bind(to: requestResult)
            .disposed(by: disposeBag)
    }
    
}
