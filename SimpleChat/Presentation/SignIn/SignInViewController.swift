//
//  SignInViewController.swift
//  SimpleChat
//
//  Created by 엄태양 on 2023/01/10.
//

import UIKit
import RxSwift
import RxCocoa

class SignInViewController: UIViewController {
    
    private var vm: SignInViewModel!
    private let disposeBag = DisposeBag()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    
    private let emailLabel = UILabel()
    private let emailTextfield = UITextField()
    private let pwdLabel = UILabel()
    private let pwdTextfield = UITextField()
    private let checkLabel = UILabel()
    private let checkTextfield = UITextField()
    
    private let saveInBtn = UIButton()
    
    private let activityIndicator = UIActivityIndicatorView()
    
    init(_ vm: SignInViewModel!) {
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
        emailTextfield.rx.text
            .orEmpty
            .bind(to: self.vm.emailData)
            .disposed(by: disposeBag)
        
        pwdTextfield.rx.text
            .orEmpty
            .bind(to: self.vm.pwdData)
            .disposed(by: disposeBag)
        
        checkTextfield.rx.text
            .orEmpty
            .bind(to: self.vm.checkData)
            .disposed(by: disposeBag)
        
        saveInBtn.rx.tap
            .bind(to: self.vm.saveBtnTap)
            .disposed(by: disposeBag)
        
        vm.loading
            .map{ !$0 }
            .bind(to: self.activityIndicator.rx.isHidden)
            .disposed(by: disposeBag)
        
        vm.requestResult
            .observe(on: MainScheduler.instance)
                        .subscribe(onNext: { result in
                            if result.isSuccess {
                                let alert = UIAlertController(title: "성공", message: result.msg, preferredStyle: .alert)
                                let action = UIAlertAction(title: "확인", style: .default) { _ in
                                    self.navigationController?.popViewController(animated: true)
                                }
                                alert.addAction(action)
                                self.present(alert, animated: true)
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
        
        activityIndicator.backgroundColor = UIColor(cgColor: CGColor(red: 0, green: 0, blue: 0, alpha: 0.7))
        activityIndicator.color = .white

        view.backgroundColor = .black
        view.addTapGesture()
        
        titleLabel.text = "Sign In"
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLabel.textColor = .white
        
        [emailTextfield, pwdTextfield, checkTextfield].forEach {
            $0.defaultUI()
        }
        
        emailLabel.text = "Email"
        pwdLabel.text = "Password"
        checkLabel.text = "Password Check"
        
        [emailLabel, pwdLabel, checkLabel].forEach {
            $0.font = .systemFont(ofSize: 20, weight: .semibold)
            $0.textColor = .white
        }
        
        pwdTextfield.isSecureTextEntry = true
        checkTextfield.isSecureTextEntry = true
        
        saveInBtn.backgroundColor = .blue
        saveInBtn.layer.cornerRadius = 5
        saveInBtn.setTitle("Save", for: .normal)
        saveInBtn.titleLabel?.textColor = .white
        saveInBtn.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        
    }
    
    private func layout() {
        
        
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        [titleLabel, emailLabel, emailTextfield, pwdLabel, pwdTextfield, checkLabel, checkTextfield, saveInBtn].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        [
            
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.topAnchor.constraint(equalTo: view.topAnchor),
            activityIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            contentView.bottomAnchor.constraint(equalTo: saveInBtn.bottomAnchor, constant: 10),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            emailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            emailTextfield.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            emailTextfield.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emailTextfield.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emailTextfield.heightAnchor.constraint(equalToConstant: 35),

            pwdLabel.topAnchor.constraint(equalTo: emailTextfield.bottomAnchor, constant: 20),
            pwdLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pwdLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            pwdTextfield.topAnchor.constraint(equalTo: pwdLabel.bottomAnchor, constant: 10),
            pwdTextfield.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pwdTextfield.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            pwdTextfield.heightAnchor.constraint(equalToConstant: 35),

            checkLabel.topAnchor.constraint(equalTo: pwdTextfield.bottomAnchor, constant: 20),
            checkLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            checkLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            checkTextfield.topAnchor.constraint(equalTo: checkLabel.bottomAnchor, constant: 10),
            checkTextfield.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            checkTextfield.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            checkTextfield.heightAnchor.constraint(equalToConstant: 35),

            saveInBtn.topAnchor.constraint(equalTo: checkTextfield.bottomAnchor, constant: 30),
            saveInBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            saveInBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            saveInBtn.heightAnchor.constraint(equalToConstant: 35),

            
        ].forEach { $0.isActive = true }
    }
    

}
