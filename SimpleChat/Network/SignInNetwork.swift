import Foundation
import RxSwift
import FirebaseAuth

struct SignInNetwork {
    let session = URLSession.shared
    
    func requestJoin(email: String, pwd: String) -> Observable<RequestResult> {
        
        return Observable<RequestResult>.create() { observer in
            Auth.auth().createUser(withEmail: email, password: pwd) { authResult, error in
                if authResult != nil {
                    observer.onNext(RequestResult(isSuccess: true, msg: "정상적으로 회원가입 되었습니다."))
                } else {
                    observer.onNext(RequestResult(isSuccess: false, msg: error!.localizedDescription))
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
        
    }
}
