//
//  SettingViewModel.swift
//  SimpleChat
//
//  Created by 엄태양 on 2023/02/06.
//

import RxSwift
import RxRelay

struct SettingViewModel {
    
    let disposeBag = DisposeBag()
    let items = Observable.just(["로그아웃","회원탈퇴"])
    let logoutRequest = PublishSubject<Void>()
    let logoutRequestResult = PublishSubject<RequestResult>()
    let deleteAccountRequest = PublishSubject<Void>()
    let deleteAccountRequestResult = PublishSubject<RequestResult>()
    
    init(_ userRepo: UserRepository = UserRepository(), _ accountRepo: AccountRepository = AccountRepository() ) {
        
        logoutRequest
            .flatMapLatest { userRepo.logout() }
            .bind(to: logoutRequestResult)
            .disposed(by: disposeBag)
        
    }
}
