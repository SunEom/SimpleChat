//
//  LoginNetwork.swift
//  SimpleChat
//
//  Created by 엄태양 on 2023/01/13.
//

import Foundation
import FirebaseAuth
import RxSwift

class LoginNetwork {
    
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
}
