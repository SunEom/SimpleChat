//
//  SettingViewController.swift
//  SimpleChat
//
//  Created by 엄태양 on 2023/02/06.
//

import UIKit
import RxSwift
import RxCocoa

class SettingViewController: UIViewController {
    let disposeBag = DisposeBag()
    var vm: SettingViewModel!
    let tableView = UITableView()
    
    init(_ vm: SettingViewModel) {
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
    
    private func bind(){
        vm.items
            .bind(to: tableView.rx.items) { tv, row, item in
                let cell = UITableViewCell()
                cell.backgroundColor = .white
                cell.textLabel?.textColor = .black
                cell.textLabel?.text = item
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .map { $0.row }
            .subscribe(onNext: { idx in
                switch(idx) {
                    case 0:
                        let alert = UIAlertController(title: "로그아웃", message: "정말로 로그아웃 하시겠습니까?", preferredStyle: .alert)
                        let confirm = UIAlertAction(title: "확인", style: .default) { _ in
                            self.vm.logoutRequest.onNext(Void())
                        }
                        let cancel = UIAlertAction(title: "취소", style: .default)
                        alert.addAction(confirm)
                        alert.addAction(cancel)
                        self.present(alert, animated: true)
                    case 1:
                        let alert = UIAlertController(title: "회원탈퇴", message: "탈퇴 후에는 복구가 불가능합니다.\n정말 탈퇴 하시겠습니까?", preferredStyle: .alert)
                        let confirm = UIAlertAction(title: "탈퇴", style: .destructive) { _ in
                            self.vm.deleteAccountRequest.onNext(Void())
                        }
                        let cancel = UIAlertAction(title: "취소", style: .default)
                        alert.addAction(confirm)
                        alert.addAction(cancel)
                        self.present(alert, animated: true)
                    default:
                        return
                }
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.tableView.cellForRow(at: $0)?.isSelected = false
            })
            .disposed(by: disposeBag)
        
        vm.logoutRequestResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                if $0.isSuccess {
                    let alert = UIAlertController(title: "성공", message: "정상적으로 로그아웃 되었습니다.", preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "확인", style: .default) { _ in
                        self.dismiss(animated: true)
                    }
                    alert.addAction(confirm)
                    self.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "실패", message: $0.msg, preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(confirm)
                    self.present(alert, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .black
        
        tableView.backgroundColor = .white
    }
    
    private func layout() {
        [tableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ].forEach { $0.isActive = true }
    }

}
