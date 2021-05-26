//
//  House.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-25.
//

import Foundation

struct House: Identifiable {
    var id: String
    var name: String
    var members: [Member]
    var payments: [Payment]
    var password: String
    static let empty = House(id: "", name: "", members: [Member](), payments: [Payment](), password: "")
    static let placeholder = House(id: "00000", name: "Home", members: [Member.placeholder, Member.placeholder2, Member.empty], payments: [Payment.placeholder], password: "p")
}
