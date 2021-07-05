//
//  Member.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-25.
//

import Foundation

struct Member: Identifiable, Equatable {
    var id: String
    var home: String
    var name: String
    var owesMe: [String : Float] = [String : Float]()
    var iOwe: [String : Float] = [String : Float]()
    var image: String
    var admin: Bool = false
    var showStatus: Bool
    var online: Bool = false
    var lastSeen: NSNumber = 0
    func dict() -> [String: Any] {
        return ["id": id, "home": home, "name": name, "admin": admin]
    }
    func dictimg() -> [String: Any] {
        return ["id": id, "home": home, "name": name, "image": image, "showStatus": showStatus, "online": true]
    }
    static let empty = Member(id: "", home: "", name: "", image: "", showStatus: false)
    static let placeholder = Member(id: "sdafgasdgsd", home:"h", name: "Johnny J", image: "", showStatus: true)
    static let placeholder2 = Member(id: "sdfasdgs", home: "h", name: "Tedward", image: "", showStatus: true, online: true)
}

struct codableMember: Identifiable, Codable {
    var id: String
    var home: String
    var name: String
    var owesMe: [String : Float] = [String : Float]()
    var iOwe: [String : Float] = [String : Float]()
    var image: String
    var admin: Bool = false
    init(member: Member){
        id = member.id
        home = member.home
        name = member.name
        owesMe = member.owesMe
        iOwe = member.iOwe
        image = member.image
        admin = member.admin
    }
    static let placeholder = codableMember(member: Member(id: "sdafgasdgsd", home:"h", name: "Johnny J", image: "", showStatus: true))
    static let placeholder2 = codableMember(member: Member(id: "sdfasdgs", home: "h", name: "Tedward", image: "", showStatus: true, online: true))

}
