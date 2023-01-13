//
//  SignInRepository.swift
//  SimpleChat
//
//  Created by 엄태양 on 2023/01/10.
//

import Foundation
import FirebaseAuth
import RxSwift

struct SignInRepository {
    private let network = SignInNetwork()
    
    func requestSignIn(_ email: String, _ pwd: String, _ check: String) -> Observable<RequestResult> {
        if let validateResult = validate(email, pwd, check) {
            return Observable.just(validateResult)
        }
    
        return network.requestJoin(email: email, pwd: pwd)
    }
    
    private func validate(_ email: String, _ pwd: String, _ check: String) -> RequestResult? {
        if pwd != check {
            return RequestResult(isSuccess: false, msg: "비밀번호가 서로 다릅니다.")
        } else if !email.contains("@"){
            return RequestResult(isSuccess: false, msg: "올바른 이메일 형식이 아닙니다.")
        } else if pwd.count < 6 {
            return RequestResult(isSuccess: false, msg: "비밀번호를 6자리 이상 입력해주세요.")
        } else { return nil }
    }
}
