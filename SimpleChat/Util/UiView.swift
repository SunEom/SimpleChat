//
//  UiView.swift
//  SimpleChat
//
//  Created by 엄태양 on 2023/01/10.
//

import UIKit

extension UIView {
    
    func addTapGesture() {
        let tg = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureHandler(_:)))
        self.addGestureRecognizer(tg)
    }
    
    @objc
    func tapGestureHandler(_ sender: UITapGestureRecognizer? = nil) {
        self.endEditing(true)
    }
}
