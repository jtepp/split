//
//  Payment.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import Foundation

struct Payment: Identifiable, Codable {
    var id: String?
    var to: String = ""
    var from: String = String()
    var reqfrom: [String] = [String]()
    var amount: Float = 0
    let time: Int
    var memo: String = ""
    var isRequest: Bool = false
    var isAn: Bool = false
    var by: String = ""
    static let empty = Payment(id: "", to: "", from: "", amount: 0, time: 0)
    static let placeholder = Payment(id: "34f43", to: "Jacob T", from: "Praw", amount: 5.6, time: 1622044000, memo: "mem")
    static let placeholdera = Payment(id: "343", to: "Jacob T", from: "Praw", amount: 5.6, time: 1621044000, memo: "mem", isAn: true)
    static let placeholderr = Payment(id: "3463", to: "Jacob T", reqfrom: ["Praw", "Schaffer", "Ethan"], amount: 5.6, time: 1620044000, memo: "mem", isRequest: true)
    static let placeholderx = Payment(id: "63", to: "Jacob T", reqfrom: ["Name"], amount: 57.6, time: 1620084000, memo: "m7em", isRequest: true)
}
