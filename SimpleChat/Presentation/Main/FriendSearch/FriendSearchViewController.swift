//
//  FriendSearchViewController.swift
//  SimpleChat
//
//  Created by 엄태양 on 2023/01/17.
//

import UIKit
import RxSwift
import RxCocoa

class FriendSearchViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    var vm: FriendSearchViewModel!
    let searchBar = UISearchBar()
    let tableView = UITableView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        attribute()
        layout()
        
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 2)
        self.vm = FriendSearchViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        searchBar.rx.searchButtonClicked
            .bind(to: vm.searchBtnTap)
            .disposed(by: disposeBag)
        
        searchBar.rx.text
            .orEmpty
            .bind(to: vm.keyword)
            .disposed(by: disposeBag)
        
        vm.list
            .bind(to: tableView.rx.items) { tv, row, item in
                let cell = UITableViewCell()
                cell.backgroundColor = .white
                cell.textLabel?.text = item.uid
                cell.textLabel?.textColor = .black
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .map {$0.row}
            .withLatestFrom(vm.list) { $1[$0] }
            .subscribe(onNext: {
                let uid = $0.uid
                let alert = UIAlertController(title: "친구 추가", message: "\($0.uid)를 추가하시겠습니까?", preferredStyle: .alert)
                
                let confirm = UIAlertAction(title: "추가", style: .default) {_ in
                    self.vm.newFriend.onNext(User(uid: uid))
                }
                let cancel = UIAlertAction(title: "취소", style: .default)
                
                alert.addAction(confirm)
                alert.addAction(cancel)
                
                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: {
                self.tableView.cellForRow(at: $0)?.isSelected = false
            })
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .subscribe(onNext: {
                self.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        vm.AddFriendRequestResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                let alert = UIAlertController(title: result.isSuccess ? "성공" : "실패", message: result.msg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                
                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
        view.addTapGesture()
    
        tableView.backgroundColor = .white
        
        searchBar.barTintColor = .white
        searchBar.autocorrectionType = .no
        searchBar.autocapitalizationType = .none
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.leftView?.tintColor = .black
    }
    
    private func layout() {
        
        [searchBar, tableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ].forEach{ $0.isActive = true }
    }
}
