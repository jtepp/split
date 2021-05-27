//
//  Payment.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import Foundation

struct Payment: Identifiable {
    var id: String?
    let to: String
    var from: String = String()
    var reqfrom: [String] = [String]()
    var amount: Float
    let time: Int
    var memo: String = ""
    var isRequest: Bool = false
    var by: String = ""
    static let empty = Payment(id: "", to: "", from: "", amount: 0, time: 0)
    static let placeholder = Payment(id: "34f43", to: "Jacob T", from: "Praw", amount: 5.6, time: 1622044000, memo: "mem")
}
