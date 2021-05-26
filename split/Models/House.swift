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
    var password: String
    static let empty = House(id: "", name: "", members: [Member(id: "", name: "", balance: 0, image: "")], password: "")
    static let placeholder = House(id: "00000", name: "Home", members: [Member.placeholder], password: "")
}
