//
//  MainViewController.swift
//  SimpleChat
//
//  Created by 엄태양 on 2023/01/17.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViewControllers([UINavigationController(rootViewController: FriendListViewController()), FriendSearchViewController()], animated: true)
        
        UITabBar.appearance().backgroundColor = .white
    }
    
}
