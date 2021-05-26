//
//  House.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-25.
//

import SwiftUI

struct House: Identifiable {
    var id: String
    var name: String
    var members: [Member]
    var password: String
    static let empty = House(id: "", name: "", members: [Member](), password: "")
    static let placeholder = House(id: "00000", name: "Home", members: [Member.placeholder], password: "")
}
