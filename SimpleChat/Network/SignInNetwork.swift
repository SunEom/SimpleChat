import Foundation
import RxSwift
import FirebaseAuth
import FirebaseDatabase

struct SignInNetwork {
    let session = URLSession.shared
    
    func requestJoin(email: String, pwd: String) -> Observable<RequestResult> {
        
        return Observable<RequestResult>.create() { observer in
            Auth.auth().createUser(withEmail: email, password: pwd) { authResult, error in
                if let authResult {
                    Database.database().reference().child("users/\(authResult.user.uid)").setValue(email as! Any) { error, _ in
                        if let error = error {
                            observer.onNext(RequestResult(isSuccess: false, msg: "오류가 발생하였습니다."))
                            print(error)
                        } else {
                            observer.onNext(RequestResult(isSuccess: true, msg: "정상적으로 회원가입 되었습니다."))
                        }
                        
                    }
                    
                } else {
                    observer.onNext(RequestResult(isSuccess: false, msg: error!.localizedDescription))
                }
            }
            return Disposables.create()
        }
        
    }
}
