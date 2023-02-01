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
                cell.textLabel?.text = item.uid
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
        
        searchBar.autocorrectionType = .no
        searchBar.autocapitalizationType = .none
        searchBar.tintColor = .black
        
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
