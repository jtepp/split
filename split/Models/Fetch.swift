//
//  Fetch.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-25.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class Fetch: ObservableObject {
    private var db = Firestore.firestore()
    
    func getHouse (h: Binding<House>, id: String) {
        db.document("houses/"+id).addSnapshotListener { (querySnapshot, error) in
            guard let doc = querySnapshot else {
                print("no house by id %s", id)
                return
            }
            let data = doc.data()
            let name = data?["name"] as? String ?? ""
            
            let password = data?["password"] as? String ?? ""
            
            h.wrappedValue = House(id: id, name: name, members: h.wrappedValue.members, payments: h.wrappedValue.payments, password: password)
            
            self.getMembers(h: h, id: id)
            
            self.getPayments(h: h, id: id)
            
        }
    }
    
    func getMembers(h: Binding<House>, id: String) {
        db.collection("houses/"+id+"/members").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("no house by id %s, or maybe no members..?", id)
                return
            }
            
            h.wrappedValue.members = documents.map({ q -> Member in
                let data = q.data()
                
                let name = data["name"] as? String ?? ""
                let owesMe = data["owesMe"] as? [String : Float] ?? [String : Float]()
                let iOwe = data["iOwe"] as? [String : Float] ?? [String : Float]()
                let image = data["image"] as? String ?? ""
                let admin = data["admin"] as? Bool ?? false
                
                return Member(id: q.documentID, name: name, owesMe: owesMe, iOwe: iOwe, image: image, admin: admin)
            })
            for member in h.wrappedValue.members {
                self.updateBalances(h: h.wrappedValue, m: member)
            }
        }
    }
    
    func getPayments(h: Binding<House>, id: String) {
        db.collection("houses/"+id+"/payments").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("no house by id %s, or maybe no payments..?", id)
                return
            }
            
            h.wrappedValue.payments = documents.map({ q -> Payment in
                let data = q.data()
                
                let to = data["to"] as? String ?? ""
                let time = data["time"] as? NSNumber ?? 0
                let from = data["from"] as? String ?? ""
                let reqfrom = data["reqfrom"] as? [String] ?? [""]
                let amount = data["amount"] as? NSNumber ?? 0
                let memo = data["memo"] as? String ?? ""
                let isRequest = data["isRequest"] as? Bool ?? false
                let by = data["by"] as? String ?? ""
                
                return Payment(id: q.documentID, to: to, from: from, reqfrom: reqfrom, amount: Float(truncating: amount), time: Int(truncating: time), memo: memo, isRequest: isRequest, by: by)
            })
            for member in h.wrappedValue.members {
                self.updateBalances(h: h.wrappedValue, m: member)
            }
        }
    }
    
    func updateImg(img: UIImage, hId: String, myId: String) {
        db.document("houses/\(hId)/members/\(myId)").updateData(["image":imgtob64(img: img.resized(toWidth: 400)!)])
    }
    
    func sendPayment(p: Payment, h: House) {
        //        let pId =
        db.collection("houses/\(h.id)/payments").addDocument(data:
                                                                ["amount":p.amount, "from":p.from, "reqfrom":p.reqfrom, "isRequest":p.isRequest, "to":p.to, "time":p.time, "memo":p.memo, "by":UserDefaults.standard.string(forKey: "myId") ?? "noID"]
        )
        //            .documentID
        for member in h.members {
            self.updateBalances(h: h, m: member)
        }
        
    }
    
    
    func updateBalances(h: House, m: Member) {
        var owesMe = [String:Float]()
        var iOwe = [String:Float]()
        
        for payment in h.payments {
            if payment.isRequest {
                if payment.to == m.name {
                    for member in payment.reqfrom {
                        //they owe me from my request
                        owesMe[member] = owesMe[member] ?? 0 + payment.amount / Float(payment.reqfrom.count)
                    }
                } else if payment.reqfrom.contains(m.name) {
                    //i owe them from their request
                    iOwe[payment.to] = iOwe[payment.to] ?? 0 + payment.amount / Float(payment.reqfrom.count)
                }
            } else { //its a payment
                if payment.to == m.name {
                    //paid to me
                    owesMe[payment.from] = owesMe[payment.from] ?? 0 - payment.amount //they owe me less now
                } else if payment.from == m.name {
                    //i paid them
                    iOwe[payment.to] = iOwe[payment.to] ?? 0 - payment.amount//i owe them less now
                }
            }
        }
        
        db.document("houses/\(h.id)/members/\(m.id)").updateData(["owesMe":owesMe, "iOwe":iOwe])
        
        
    }
    
    
    func deletePayment(p: Payment, h: House) {
        db.document("houses/\(h.id)/payments/\(p.id!)").delete()
        for member in h.members {
            self.updateBalances(h: h, m: member)
        }
    }
    
    func removeMember(m: Member, h: House) {
        let docRef = db.document("houses/\(h.id)/members/\(m.id)")
        docRef.getDocument { (documentSnapshot, err) in
            guard let doc = documentSnapshot else {
                print("couldn't get doc \(String(describing: err))")
                return
            }
            self.db.document("waitingRoom/\(m.id)").setData(doc.data()!)
            self.db.document("waitingRoom/\(m.id)").updateData(["iOwe" : [String:Float](), "owesMe": [String:Float]()], completion: { (err) in
                self.db.collection("houses/\(h.id)/payments").getDocuments { (querySnapshot, err) in
                    guard let documents = querySnapshot?.documents else {
                        print("remove member no payments or something")
                        return
                    }
                    for doc in documents.filter({ (doc) -> Bool in
                        let d = doc.data()
                        let to = (d["to"] ?? "") as! String
                        let from = (d["from"] ?? "") as! String
                        let reqfrom = (d["reqfrom"] ?? [""]) as! [String]
                        return to.contains(m.name) || from.contains(m.name) || reqfrom.contains(m.name)
                    }) {
                        self.db.document("houses/\(h.id)/payments/\(doc.documentID)").delete()
                    }
                }
                docRef.delete()
            })
        }
        
    }
    func swapAdmin(m:Member, h:House){
        db.collection("houses/"+h.id+"/members").getDocuments{ (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("no house by id %s, or maybe no members..?", h.id)
                return
            }
            documents.forEach { (doc) in
                let id = doc.documentID
                self.db.document("houses/\(h.id)/members/\(id)").updateData(["admin": id == m.id ? true : false])
            }
        }
    }
}

func idfromnamehouse(name: String, house: House) -> String {
    return house.members.first { (m) -> Bool in
        return m.name == name
    }?.id ?? ""
}
