//
//  FriendListViewController.swift
//  SimpleChat
//
//  Created by 엄태양 on 2023/01/17.
//

import UIKit
import RxSwift
import RxCocoa

class FriendListViewController: UIViewController {

    var vm: FriendListViewModel!
    let disposeBag = DisposeBag()
    let tableView = UITableView()
    let settingButton = UIBarButtonItem()
    
    init () {
        super.init(nibName: nil, bundle: nil)
        self.vm = FriendListViewModel()
        tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
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
        vm.listRefresh.onNext(Void())
    }
    
    private func bind() {
        vm.friends
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items) { tv, row, friend in
                let cell = UITableViewCell()
                cell.textLabel?.text = friend.uid
                cell.textLabel?.textColor = .black
                cell.accessoryType = .disclosureIndicator
                cell.backgroundColor = .white
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: {
                self.tableView.cellForRow(at: $0)?.isSelected = false
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map { $0.row }
            .withLatestFrom(vm.friends) { $1[$0] }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.navigationController?.pushViewController(ChatRoomViewController(ChatRoomViewModel(friend: $0)), animated: true)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemDeleted
            .map { $0.row }
            .withLatestFrom(vm.friends) { $1[$0] }
            .subscribe(onNext: { friend in
                let alert = UIAlertController(title: "알림", message: "\(friend.uid)님을 친구 목록에서 삭제하시겠습니까?", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "취소", style: .cancel)
                let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
                    self.vm.deleteFriend.onNext(friend)
                }
                
                alert.addAction(cancel)
                alert.addAction(delete)
                
                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
        
        vm.deleteFriendResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                let alert = UIAlertController(title: result.isSuccess ? "성공" : "오류", message: result.msg, preferredStyle: .alert)
                let confirm = UIAlertAction(title: "확인", style: .default)
                
                alert.addAction(confirm)
                
                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
        
        settingButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.navigationController?.pushViewController(SettingViewController(SettingViewModel()), animated: true)
            })
            .disposed(by: disposeBag)
            
    }
    
    
    private func attribute() {
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        view.backgroundColor = .white
        self.navigationItem.title = "Friends"
        
        settingButton.image = UIImage(systemName: "gearshape")
        settingButton.tintColor = .black
        navigationItem.rightBarButtonItem = settingButton
        
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.backgroundColor = .white
    }
    
    private func layout() {
        [tableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ].forEach { $0.isActive = true}
    }

    

}
