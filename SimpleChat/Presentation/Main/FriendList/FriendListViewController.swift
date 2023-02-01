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
        attribute()
        layout()
    }
    
    private func bind() {
        vm.friends
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items) { tv, row, friend in
                let cell = UITableViewCell()
                cell.textLabel?.text = friend.uid
                cell.accessoryType = .disclosureIndicator
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    
    private func attribute() {
        view.backgroundColor = .white
        self.navigationItem.title = "Friends"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
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
