//
//  Payment.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import Foundation

struct Payment: Identifiable, Codable {
    var id: String = UUID().uuidString
    var bulkid: String = ""
    var to: String = ""
    var from: String = String()
    var reqfrom: [String] = [String]()
    var amount: Float = 0
    let time: Int
    var memo: String = ""
    var type: paymentType
    var special: String = ""
    var by: String = ""
    var editLog: [String: String] = [String: String]()
    static let empty = Payment(id: "", to: "", from: "", amount: 0, time: 0, type: .payment)
    static let placeholder = Payment(id: "34f43", to: "Jacob T", from: "Praw", amount: 5.6, time: 1622044000, memo: "mem", type: .payment, special: "compactor", editLog: ["IDPERSON":"liked", "PERSONID": "questioned","IDPERSONID":"disliked","1639966355": "A changed amount from 2.36 to 3.26", "1639967355": "Xxxxx sfdfd changed To from Jfsdfasd to ksfk"])
    static let placeholderp = Payment(id: "34f4r3", to: "Jacob T", from: "Praw", amount: 5.6, time: 1622044300, memo: "mem", type: .payment, special: "quicksettle", editLog: ["1639966355": "A changed amount from 2.36 to 3.26", "1639967355": "Xxxxx sfdfd changed To from Jfsdfasd to ksfk"])
    static let placeholdera = Payment(id: "343", to: "Jacob T", from: "Praw", amount: 5.6, time: 1621044000, memo: "mem", type: .announcement)
    static let placeholderm = Payment(id: "34443", to: "", from: "Praw", time: 1621044000, memo: "mem", type: .groupmessage)
    static let placeholderr = Payment(id: "3463", to: "Jacob T", reqfrom: ["Devon", "Sarah", "George"], amount: 5.6, time: 1620044000, memo: "mem", type: .request, special: "includeself")
    static let placeholderx = Payment(id: "63", to: "Jacob T", reqfrom: ["Name", "2"], amount: 57.6, time: 1620084000, memo: "m7em", type: .request)
    func toString() -> String {
        return "\(id ?? "") \(to) \(from) \(reqfrom.description) \(amount) \(time) \(memo)".lowercased()
        
    }
}

enum paymentType: Codable {
    case payment
    case request
    case announcement
    case groupmessage
    case unknown
}


func stringToPT(_ s:String)-> paymentType {
    switch (s) {
    case "payment": return .payment
    case "request": return .request
    case "groupmessage": return .groupmessage
    case "announcement": return .announcement
    default: return .unknown
    }
}

func ptToString(_ p:paymentType)-> String {
    switch(p) {
    case .payment: return "payment"
    case .request: return "request"
    case .announcement: return "announcement"
    case .groupmessage: return "groupmessage"
    case .unknown: return "unknown"
    }
}
