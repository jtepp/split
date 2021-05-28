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
    
    func getHouse (h: Binding<House>, inWR: Binding<Bool>, noProf: Binding<Bool>) {
        let id = UserDefaults.standard.string(forKey: "houseId") ?? ""
        let myId = UserDefaults.standard.string(forKey: "myId") ?? ""
        
        print("ID:    \(id)")
        print("ME:    \(myId)")
        print("H:     \(h.wrappedValue)")
        
        if id != "" && id != "waitingRoom" { // has real house id
            print("has real hid \(id) \(myId)")
            inWR.wrappedValue = false
            noProf.wrappedValue = false
            
            
            
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
                
                if h.wrappedValue.name == "" && h.wrappedValue.members.isEmpty && h.wrappedValue.id != "" {
                    h.wrappedValue = House.empty
                    UserDefaults.standard.set("", forKey: "houseId")
                    UserDefaults.standard.set("", forKey: "myId")
                }
                
                if h.wrappedValue.members.first(where: { (m) -> Bool in
                    return m.id == UserDefaults.standard.string(forKey: "myId")
                }) == nil && h.wrappedValue.id != "" { //if u dont exist in the house and its not just empty
                    //if ur an alien, go to void, otherwise get waitingRoomed
                    if myId == "" {
                        print("gotovoid")
                        UserDefaults.standard.set("", forKey: "houseId")
                        noProf.wrappedValue = true
                        inWR.wrappedValue = true
                    } else {
                        print("wred")
                        UserDefaults.standard.set("waitingRoom", forKey: "houseId")
                        noProf.wrappedValue = false
                    }
                    inWR.wrappedValue = true
                }
                
            }
        }
        //        else if id == "waitingRoom" && myId != "" { //in waiting room and account exists
        //            print("in waiting room and account exists")
        //            inWR.wrappedValue = true
        //            noProf.wrappedValue = false
        //            db.document("waitingRoom/"+myId).addSnapshotListener { (querySnapshot, error) in
        //                guard let doc = querySnapshot?.data() else {
        //                    //                    print("asfasdfjkasd \(error!)")
        //
        ////                    inWR.wrappedValue = true
        ////                    noProf.wrappedValue = true
        //
        //                    //                    //set id bound and ud to ""
        //                    //                    if h.wrappedValue.members.first(where: { (m) -> Bool in
        //                    //                        return m.id == UserDefaults.standard.string(forKey: "myId")
        //                    //                    }) == nil && !h.wrappedValue.members.isEmpty && h.wrappedValue.id != "" { //if u dont exist in the house and its not just empty
        //                    //                        //if ur an alien, go to void, otherwise get waitingRoomed
        //                    //                        if myId == "" {
        //                    //                            UserDefaults.standard.set("", forKey: "houseId")
        //                    //                            noProf.wrappedValue = true
        //                    //                        } else {
        //                    //                            UserDefaults.standard.set("waitingRoom", forKey: "houseId")
        //                    //                            noProf.wrappedValue = false
        //                    //                        }
        //                    //                        inWR.wrappedValue = true
        //                    //                    }
        //
        //                    return
        //                }
        //                let data = doc
        //                print(data)
        //                var e = House.empty
        //                let newMember = Member(id: myId, home: "waitingRoom", name: (data["name"] ?? "") as! String, image: (data["image"] ?? "") as! String)
        //                e.members = [newMember]
        //                h.wrappedValue = e //empty house
        //
        //            }
        //        } else if id == "waitingRoom" && myId == "" {
        //            print("get out of waiting room alien")
        //            inWR.wrappedValue = true
        //            noProf.wrappedValue = true
        //            UserDefaults.standard.set("", forKey: "houseId") //get out of waiting room alien
        //        } else if id == "" {
        //            print("where u belong")
        //            UserDefaults.standard.set("", forKey: "houseId")
        //            inWR.wrappedValue = true
        //            noProf.wrappedValue = true
        //        }
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
                let home = data["home"] as? String ?? ""
                let owesMe = data["owesMe"] as? [String : Float] ?? [String : Float]()
                let iOwe = data["iOwe"] as? [String : Float] ?? [String : Float]()
                let image = data["image"] as? String ?? ""
                let admin = data["admin"] as? Bool ?? false
                
                return Member(id: q.documentID, home: home, name: name, owesMe: owesMe, iOwe: iOwe, image: image, admin: admin)
            })
            for member in h.wrappedValue.members {
                self.updateBalances(h: h.wrappedValue, m: member)
            }
        }
    }
    
    //    func updateMember(m: Binding<Member>) {
    //        let hid = UserDefaults.standard.string(forKey: "houseId")
    //        db.document("houses/\(hid)/members/\(m.wrappedValue.id)").addSnapshotListener { (documentSnapshot, err) in
    //            guard let data = documentSnapshot?.data() else {
    //                print("dsfasddasfasd;flj")
    //                return
    //            }
    //            let name = data["name"] as? String ?? ""
    //            let home = data["home"] as? String ?? ""
    //            let owesMe = data["owesMe"] as? [String : Float] ?? [String : Float]()
    //            let iOwe = data["iOwe"] as? [String : Float] ?? [String : Float]()
    //            let image = data["image"] as? String ?? ""
    //            let admin = data["admin"] as? Bool ?? false
    //
    //            m.wrappedValue.name = name
    //            m.wrappedValue.home = home
    //            m.wrappedValue.owesMe = owesMe
    //            m.wrappedValue.iOwe = iOwe
    //            m.wrappedValue.image = image
    //            m.wrappedValue.admin = admin
    //        }
    //    }
    //
    
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
        let id = UserDefaults.standard.string(forKey: "myId")
        print("UPDATEIMG")
        db.document("houses/\(hId)/members/\(id ?? "EMPTYIMG")").updateData(["image":imgtob64(img: img.resized(toWidth: 400)!)])
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
        //        let id = UserDefaults.standard.string(forKey: "myId")
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
            self.db.document("waitingRoom/\(m.id)").updateData(["home":"waitingRoom", "iOwe" : [String:Float](), "owesMe": [String:Float]()], completion: { (err) in
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
    func addToWR(m:Member, myId: Binding<String>, h: Binding<House>){
        db.collection("waitingRoom").addDocument(data: ["name":m.name, "image":m.image]).getDocument { (documentSnapshot, err) in
            guard let doc = documentSnapshot?.data() else {
                print("wr add to err")
                return
            }
            UserDefaults.standard.set(documentSnapshot?.documentID ?? "", forKey: "myId")
            myId.wrappedValue = documentSnapshot?.documentID ?? "AAAAAAAAAAA"
            let e = Member(id: documentSnapshot?.documentID ?? "", home: "waitingRoom", name: (doc["name"] ?? "") as! String, image: (doc["image"] ?? "") as! String)
            h.members.wrappedValue.append(e)
            
        }
        UserDefaults.standard.set("waitingRoom", forKey: "houseId")
        
        
    }
    
    func joinHouse(hh: Binding<House>, m: Binding<Member>, hId: String, password: String, showAlert: Binding<Bool>, tapped: Binding<Bool>, msg: Binding<String>, inWR: Binding<Bool>, forceAdmin: Bool = false) {
        var house = House.empty.id
        db.collection("houses").getDocuments { (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                print(err.debugDescription)
                return
            }
            
            documents.forEach { (h) in
                if h.documentID == hId {
                    house = h.documentID
                    let d = h.data()
                    let p = (d["password"] ?? "") as! String
                    
                    if password == p {
                        //add this member to house, remove from wr set userdefaults and call for a refresh
                        let mm = m.wrappedValue
                        print("mm \(mm)")
                        print("house \(house)")
                        print("hid \(h.documentID)")
                        UserDefaults.standard.set(mm.id, forKey: "myId")
                        self.db.document("houses/\(house)/members/\("\(mm.id)")").setData(["name" : mm.name, "image" : mm.image, "home" : h.documentID, "admin": forceAdmin ? true : mm.admin]) { _ in
                            self.getHouse(h: hh, inWR: inWR, noProf: .constant(false))
                            self.db.document("waitingRoom/\(mm.id)").delete()
                            UserDefaults.standard.set(mm.id, forKey: "myId")
                            UserDefaults.standard.set(house, forKey: "houseId")
                            inWR.wrappedValue = false
                        }
                    } else {
                        showAlert.wrappedValue = true
                        tapped.wrappedValue = false
                        msg.wrappedValue = "Incorrect password"
                    }
                    
                }
            }
            if house == House.empty.id {
                showAlert.wrappedValue = true
                tapped.wrappedValue = false
                msg.wrappedValue = "House not found"
            }
            tapped.wrappedValue = false
        }
    }
    
    func createHouse(hh: Binding<House>, m: Binding<Member>, name: String, password: String, tapped: Binding<Bool>, inWR: Binding<Bool>) {
        let id = db.collection("houses").addDocument(data: ["name" : name, "password" : password]).documentID
        m.wrappedValue.home = id
        m.wrappedValue.admin = true
        hh.wrappedValue.members = [m.wrappedValue]
//        db.collection("houses/\(id)/members").addDocument(data: ["admin" : true, "name" : m.wrappedValue.name, "home" : id, "image" : m.wrappedValue.id]) { (err) in
            UserDefaults.standard.set(m.wrappedValue.id, forKey: "myId")
            UserDefaults.standard.set(id, forKey: "houseId")
        self.joinHouse(hh: hh, m: m, hId: id, password: password, showAlert: .constant(false), tapped: tapped, msg: .constant(""), inWR: inWR, forceAdmin: true)
//        }
    }
    
    func leaveHouse(m: Binding<Member>, inWR: Binding<Bool>) {
        self.db.collection("houses/\(m.wrappedValue.home)/payments").getDocuments { (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                print("remove member no payments or something")
                return
            }
            for doc in documents.filter({ (doc) -> Bool in
                let d = doc.data()
                let to = (d["to"] ?? "") as! String
                let from = (d["from"] ?? "") as! String
                let reqfrom = (d["reqfrom"] ?? [""]) as! [String]
                return to.contains(m.wrappedValue.name) || from.contains(m.wrappedValue.name) || reqfrom.contains(m.wrappedValue.name)
            }) {
                self.db.document("houses/\(m.wrappedValue.home)/payments/\(doc.documentID)").delete()
            }
        }
        let h = m.wrappedValue.home
        m.wrappedValue.home = "waitingRoom"
        db.collection("waitingRoom").addDocument(data: ["name" : m.wrappedValue.name, "image" : m.wrappedValue.image, "home" : "waitingRoom", "admin": false]) { (_) in
            inWR.wrappedValue = true
            self.db.document("houses/\(h)/members/\(m.wrappedValue.id)").delete()
        }
        
    }
    func eraseHouse(m: Binding<Member>, inWR: Binding<Bool>) {
        self.db.collection("houses/\(m.wrappedValue.home)/payments").getDocuments { (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                print("remove member no payments or something")
                return
            }
            for doc in documents.filter({ (doc) -> Bool in
                let d = doc.data()
                let to = (d["to"] ?? "") as! String
                let from = (d["from"] ?? "") as! String
                let reqfrom = (d["reqfrom"] ?? [""]) as! [String]
                return to.contains(m.wrappedValue.name) || from.contains(m.wrappedValue.name) || reqfrom.contains(m.wrappedValue.name)
            }) {
                self.db.document("houses/\(m.wrappedValue.home)/payments/\(doc.documentID)").delete()
            }
        }
        db.document("houses/\(m.wrappedValue.home)/members/\(m.wrappedValue.id)").delete()
        db.document("houses/\(m.wrappedValue.home)").delete()
        m.wrappedValue.home = "waitingRoom"
        db.collection("waitingRoom").addDocument(data: ["name" : m.wrappedValue.name, "image" : m.wrappedValue.image, "home" : "waitingRoom", "admin": false]) { (_) in
            inWR.wrappedValue = true
        }
    }
    
}

func idfromnamehouse(name: String, house: House) -> String {
    return house.members.first { (m) -> Bool in
        return m.name == name
    }?.id ?? ""
}
