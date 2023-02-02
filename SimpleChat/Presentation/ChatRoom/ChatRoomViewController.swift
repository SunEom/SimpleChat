//
//  ChatRoomViewController.swift
//  SimpleChat
//
//  Created by 엄태양 on 2023/02/01.
//

import UIKit
import RxSwift
import RxCocoa

class ChatRoomViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    var vm : ChatRoomViewModel!
    let tableView = UITableView()
    let inputTextfield = UITextField()
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
    }
    
    private func attribute() {
        view.addTapGesture()
        navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        view.backgroundColor = .white
        
        
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        
        inputTextfield.defaultUI()
        inputTextfield.layer.cornerRadius = 20
        inputTextfield.layer.borderWidth = 1.0
        inputTextfield.layer.borderColor = UIColor.black.cgColor
        
        sendBtn.backgroundColor = .lightGray
        sendBtn.layer.cornerRadius = 20
        sendBtn.setImage(UIImage(systemName: "paperplane"), for: .normal)
        sendBtn.tintColor = .black
        
    }
    
    private func layout() {
        [tableView, inputTextfield, sendBtn].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputTextfield.topAnchor),
            
            inputTextfield.heightAnchor.constraint(equalToConstant: 40),
            inputTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            inputTextfield.trailingAnchor.constraint(equalTo: sendBtn.leadingAnchor, constant: -10),
            inputTextfield.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            sendBtn.heightAnchor.constraint(equalToConstant: 40),
            sendBtn.widthAnchor.constraint(equalToConstant: 40),
            sendBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            sendBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
        ].forEach { $0.isActive = true }
    }

}
