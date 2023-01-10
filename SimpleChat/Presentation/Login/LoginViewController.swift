//
//  LoginViewController.swift
//  SimpleChat
//
//  Created by 엄태양 on 2023/01/10.
//

import UIKit

class LoginViewController: UIViewController {
    
    private var vm: LoginViewModel! = nil
    
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
        
    }
    
    private func attribute() {
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
