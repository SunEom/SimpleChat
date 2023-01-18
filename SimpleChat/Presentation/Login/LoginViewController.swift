//
//  LoginViewController.swift
//  SimpleChat
//
//  Created by 엄태양 on 2023/01/10.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class LoginViewController: UIViewController {
    
    private var vm: LoginViewModel! = nil
    private let disposeBag = DisposeBag()
    
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let tfStackView = UIStackView()
    private let emailTextField = UITextField()
    private let pwdTextField = UITextField()
    private let loginBtn = UIButton()
    private let signInBtn = UIButton()
    
    init(_ vm: LoginViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.vm = vm
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        attribute()
        layout()
    }
    
    private func bind() {
        signInBtn.rx.tap
            .asDriver()
            .drive(onNext: {
                self.navigationController?.pushViewController(SignInViewController(SignInViewModel()), animated: true)
            })
            .disposed(by: disposeBag)
        
        emailTextField.rx.text
            .orEmpty
            .bind(to: vm.emailData)
            .disposed(by: disposeBag)
        
        pwdTextField.rx.text
            .orEmpty
            .bind(to: vm.pwdData)
            .disposed(by: disposeBag)
        
        loginBtn.rx.tap
            .bind(to: vm.loginBtnTap)
            .disposed(by: disposeBag)
        
        vm.loginResult
            .observe(on: MainScheduler.instance)
                        .subscribe(onNext: { result in
                            if result.isSuccess {
                                let vc =  MainViewController()
                                vc.modalPresentationStyle = .fullScreen
                                vc.modalTransitionStyle = .crossDissolve
                                self.present(vc, animated: true)
                            } else {
                                let alert = UIAlertController(title: "실패", message: result.msg, preferredStyle: .alert)
                                let action = UIAlertAction(title: "확인", style: .default)
                                alert.addAction(action)
                                self.present(alert, animated: true)
                            }
                        })
                        .disposed(by: disposeBag)
    }
    
    private func attribute() {
        
        view.backgroundColor = .black
        view.addTapGesture()
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 50
        
        tfStackView.axis = .vertical
        tfStackView.distribution = .fill
        tfStackView.spacing = 10
        
        titleLabel.text = "SimpleChat 💬"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLabel.textAlignment = .center
        
        [emailTextField, pwdTextField].forEach {
            $0.defaultUI()
        }
        
        emailTextField.placeholder = "Email"
        pwdTextField.placeholder = "Password"
        
        pwdTextField.isSecureTextEntry = true
        
        loginBtn.backgroundColor = .blue
        loginBtn.layer.cornerRadius = 5
        loginBtn.setTitle("Login", for: .normal)
        loginBtn.titleLabel?.textColor = .white
        loginBtn.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        
        signInBtn.backgroundColor = .gray
        signInBtn.layer.cornerRadius = 5
        signInBtn.setTitle("Sign in", for: .normal)
        signInBtn.titleLabel?.textColor = .white
        signInBtn.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
    
    }
    
    private func layout() {
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        [titleLabel, tfStackView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [emailTextField, pwdTextField, loginBtn, signInBtn].forEach {
            tfStackView.addArrangedSubview($0)
        }
        
        [
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            pwdTextField.heightAnchor.constraint(equalToConstant: 40),
            
        ].forEach{ $0.isActive = true }
    
    }

}
