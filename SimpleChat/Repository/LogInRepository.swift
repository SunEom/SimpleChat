//
//  LogInRepository.swift
//  SimpleChat
//
//  Created by 엄태양 on 2023/01/13.
//

import Foundation
import RxSwift

struct LoginRepository {
    
    let network = LoginNetwork()
    
    func loginRequest(email: String, pwd: String) -> Observable<RequestResult> {
        if let result = validate(email, pwd) {
            return Observable.just(result)
        }
        return network.requestLogin(email: email, pwd: pwd)
    }
    
    private func validate(_ email: String, _ pwd: String) -> RequestResult? {
        if !email.contains("@"){
            return RequestResult(isSuccess: false, msg: "올바른 이메일 형식이 아닙니다.")
        } else if pwd.count < 6 {
            return RequestResult(isSuccess: false, msg: "비밀번호를 6자리 이상 입력해주세요.")
        } else { return nil }
    }
}
