//
//  BubbleTableViewCell.swift
//  SimpleChat
//
//  Created by 엄태양 on 2023/02/02.
//

import UIKit
import RxSwift
import RxCocoa

class BubbleCell: UITableViewCell {

    let disposeBag = DisposeBag()
    var vm : BubbleViewModel!
    let otherChat = UITextView()
    let myChat = UITextView()
    
    init(msg: Message) {
        super.init(style: .default, reuseIdentifier: K.tableViewCell.bubbleCell)
        self.vm = BubbleViewModel(msg)
        bind()
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        vm.contents
            .observe(on: MainScheduler.instance)
            .bind(to: otherChat.rx.text)
            .disposed(by: disposeBag)
        
        vm.contents
            .observe(on: MainScheduler.instance)
            .bind(to: myChat.rx.text)
            .disposed(by: disposeBag)
        
        vm.isMine
            .observe(on: MainScheduler.instance)
            .bind(to: otherChat.rx.isHidden)
            .disposed(by: disposeBag)
        
        vm.isMine
            .observe(on: MainScheduler.instance)
            .map { !$0 }
            .bind(to: myChat.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func attribute(){
        backgroundColor = .white
        otherChat.backgroundColor = .lightGray
        myChat.backgroundColor = .secondarySystemFill
        [otherChat, myChat].forEach {
            $0.textColor = .black
            $0.isEditable = false
            $0.isScrollEnabled = false
            $0.font = .systemFont(ofSize: 15)
            $0.layer.cornerRadius = 5
            $0.textContainer.lineFragmentPadding = 10
        }
    }
    
    private func layout() {
        [otherChat, myChat].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            otherChat.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            otherChat.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            otherChat.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -100),
            
            myChat.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            myChat.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 100),
            myChat.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            contentView.bottomAnchor.constraint(equalTo: otherChat.bottomAnchor, constant: 10)
            
        ].forEach { $0.isActive = true}
    }

}
