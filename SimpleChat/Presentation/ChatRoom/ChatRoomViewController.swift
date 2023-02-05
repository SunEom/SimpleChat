//
//  ChatRoomViewController.swift
//  SimpleChat
//
//  Created by 엄태양 on 2023/02/01.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

class ChatRoomViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    var vm : ChatRoomViewModel!
    let tableView = UITableView()
    let inputTextView = UITextView()
    let sendBtn = UIButton()
    
    init(_ vm: ChatRoomViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.vm = vm
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        attribute()
    }
    
    private func bind() {
        vm.chatWith
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.title = $0.uid
            })
            .disposed(by: disposeBag)
            
        vm.chats
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items) { tv, row, msg in
                return BubbleCell(msg: msg)
            }
            .disposed(by: disposeBag)
        
        sendBtn.rx.tap
            .withLatestFrom(vm.chatWith)
            .withLatestFrom(inputTextView.rx.text.orEmpty) { ($0, $1) }
            .map { (user, msg) in
                self.inputTextView.text = ""
                return Message(to: user.uid, from: Auth.auth().currentUser?.uid ?? "", contents: msg, date: Date.dateToString())
            }
            .filter{ $0.from != ""}
            .bind(to: vm.newChats)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.addTapGesture()
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        view.backgroundColor = .white
        navigationController?.navigationBar.backgroundColor = .white
        
        
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        
        inputTextView.font = .systemFont(ofSize: 15)
        inputTextView.backgroundColor = .white
        inputTextView.textColor = .black
        inputTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        inputTextView.layer.cornerRadius = 20
        inputTextView.layer.borderWidth = 1.0
        inputTextView.layer.borderColor = UIColor.black.cgColor
    
        
        sendBtn.backgroundColor = .lightGray
        sendBtn.layer.cornerRadius = 20
        sendBtn.setImage(UIImage(systemName: "paperplane"), for: .normal)
        sendBtn.tintColor = .black
        
    }
    
    private func layout() {
        [tableView, inputTextView, sendBtn].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputTextView.topAnchor, constant: -10),
            
            inputTextView.heightAnchor.constraint(equalToConstant: 40),
            inputTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            inputTextView.trailingAnchor.constraint(equalTo: sendBtn.leadingAnchor, constant: -10),
            inputTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            sendBtn.heightAnchor.constraint(equalToConstant: 40),
            sendBtn.widthAnchor.constraint(equalToConstant: 40),
            sendBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            sendBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
        ].forEach { $0.isActive = true }
    }

}
