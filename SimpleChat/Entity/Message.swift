//
//  Message.swift
//  SimpleChat
//
//  Created by 엄태양 on 2023/02/02.
//

import Foundation

struct Message {
    let to: String
    let from: String
    let contents: String
    let date: String

    var toDictionary: [String: String?] {
        let dict: [String: String] = ["to": to, "from": from, "contents" : contents, "date" : date]
        return dict
    }
}
