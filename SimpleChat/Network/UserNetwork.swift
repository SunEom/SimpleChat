//
//  LoginNetwork.swift
//  SimpleChat
//
//  Created by 엄태양 on 2023/01/13.
//

import Foundation
import FirebaseAuth
import RxSwift

class UserNetwork {
    
    func requestLogin(email: String, pwd: String) -> Observable<RequestResult> {
        
        return Observable<RequestResult>.create { observer in
            Auth.auth().signIn(withEmail: email, password: pwd) { authResult, error in
                if authResult != nil {
                    observer.onNext(RequestResult(isSuccess: true, msg: "정상적으로 로그인되었습니다."))
                }
                
                if error != nil {
                    observer.onNext(RequestResult(isSuccess: false, msg: error!.localizedDescription))
                }
              
            }
            
            return Disposables.create()
        }
    }
    
    func requestLogout() -> Observable<RequestResult> {
        do {
            try Auth.auth().signOut()
            return Observable.just(RequestResult(isSuccess: true, msg: "정상적으로 로그아웃 되었습니다."))
        } catch {
            return Observable.just(RequestResult(isSuccess: false, msg: "오류가 발생했습니다. 잠시 후에 시도해주세요."))
        }
    }
}
