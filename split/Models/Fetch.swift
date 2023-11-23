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
    //    init() {
    //        Firestore.firestore().clearPersistence()
    //    }
    
    static func getHouse (h: Binding<House>, m: Binding<Member>, inWR: Binding<Bool>, noProf: Binding<Bool>, showInvite: Binding<Bool> = .constant(false), completion: @escaping () -> Void = {}) {
        let db = Firestore.firestore()
        if (UserDefaults.standard.string(forKey: "houseId") ?? "") != ""
        {
            let id = UserDefaults.standard.string(forKey: "houseId") ?? ""
            let myId = UserDefaults.standard.string(forKey: "myId") ?? ""
            
            print("ID:    \(id)")
            print("ME:    \(myId)")
            //            print("H:     \(h.wrappedValue)")
            
            if id != "" && id != "waitingRoom" { // has real house id
                print("has real hid \(id) \(myId)")
                showInvite.wrappedValue = false
                //                inWR.wrappedValue = false
                noProf.wrappedValue = false
                
                UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set(id, forKey: "houseId")
                UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set(myId, forKey: "myId")
                if m.wrappedValue.name != "" {
                    UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set(m.wrappedValue.name, forKey: "myName")
                }
                
                
                db.collection("houses").document(id).addSnapshotListener { (querySnapshot, error) in
                    if (querySnapshot?.exists ?? false) {
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
                        
                        
                        let t = UserDefaults.standard.string(forKey: "fcm") ?? ""
                        
                        if t != "" {
                            self.placeToken(h: h, id: myId, token: t)
                        }
                        
                        if h.wrappedValue.members.first(where: { (m) -> Bool in
                            return m.id == UserDefaults.standard.string(forKey: "myId")
                        }) != nil {
                            print("setdead\(m.wrappedValue.id)")
                            m.wrappedValue = h.wrappedValue.members.first(where: { (m) -> Bool in
                                return m.id == UserDefaults.standard.string(forKey: "myId")
                            })!
                            UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set(m.wrappedValue.name, forKey: "myName")
                            print("setdead222\(m.wrappedValue.id)")
                        }
                        
                        
                        completion()
                        if h.wrappedValue.members.first(where: { (m) -> Bool in
                            return m.id == UserDefaults.standard.string(forKey: "myId")
                        }) == nil && !h.wrappedValue.members.isEmpty && h.wrappedValue.id != "" { //if u dont exist in the house and its not just empty
                            //if ur an alien, go to void, otherwise get waitingRoomed
                            //                            if UserDefaults.standard.string(forKey: "houseId") != "waitingRoom" {
                            if myId == "" {
                                print("gotovoid")
                                UserDefaults.standard.set("", forKey: "houseId")
                                UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set("", forKey: "houseId")
                                noProf.wrappedValue = true
                                inWR.wrappedValue = true
                            } else {
                                print("wred")
                                UserDefaults.standard.set("waitingRoom", forKey: "houseId")
                                UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set("waitingRoom", forKey: "houseId")
                                noProf.wrappedValue = false
                            }
                            inWR.wrappedValue = true
                            //                        }
                        }
                        
                    } else {
                        print("gotovoid2")
                        UserDefaults.standard.set("", forKey: "houseId")
                        UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set("", forKey: "houseId")
                        UserDefaults.standard.set("", forKey: "myId")
                        UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set("", forKey: "myId")
                        UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set("", forKey: "myName")
                        h.wrappedValue = .empty
                        
                        noProf.wrappedValue = true
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
        }}
    
    static func getMembers(h: Binding<House>, id: String) {
        let db = Firestore.firestore()
        db.collection("houses").document(id).collection("members").addSnapshotListener { (querySnapshot, error) in
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
                let showStatus = data["showStatus"] as? Bool ?? false
                let online = data["online"] as? Bool ?? false
                let lastSeen = data["lastSeen"] as? NSNumber ?? 0
                //                print("DFSSSS: \(name) \(data["lastSeen"])")
                return Member(id: q.documentID, home: home, name: name, owesMe: owesMe, iOwe: iOwe, image: image, admin: admin, showStatus: showStatus, online: online, lastSeen: lastSeen)
            })
            for member in h.wrappedValue.members {
                self.updateBalances(h: h.wrappedValue, m: member)
            }
        }
    }
    
    //    static func updateMember(m: Binding<Member>) {
    //    let db = Firestore.firestore()
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
    
    static func getPayments(h: Binding<House>, id: String) {
        let db = Firestore.firestore()
        db.collection("houses").document(id).collection("payments").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("no house by id %s, or maybe no payments..?", id)
                return
            }
            
            h.wrappedValue.payments = documents.map({ q -> Payment in
                let data = q.data()
                
                let to = data["to"] as? String ?? ""
                let time = data["time"] as? NSNumber ?? 0
                let from = data["from"] as? String ?? ""
                let reqfrom = data["reqfrom"] as? [String] ?? [String]()
                let amount = data["amount"] as? NSNumber ?? 0
                let memo = data["memo"] as? String ?? ""
                let special = data["special"] as? String ?? ""
                let type = data["type"] as? String ?? "unknown"
                let by = data["by"] as? String ?? ""
                let editLog = data["edits"] as? [String: String] ?? [String: String]()
                
                return Payment(id: q.documentID, to: to, from: from, reqfrom: reqfrom, amount: Float(truncating: amount), time: Int(truncating: time), memo: memo, type: stringToPT(type), special: special, by: by, editLog: editLog)
            })
            for member in h.wrappedValue.members {
                self.updateBalances(h: h.wrappedValue, m: member)
            }
        }
    }
    
    static func updateImg(img: UIImage, hId: String, myId: String) {
        let db = Firestore.firestore()
        print("UPDATEIMG")
        db.collection("houses").document(hId).collection("members").document(myId).updateData(["image":imgtob64(img: img.resized(toWidth: 600)!)])
    }
    
    static func sendPayment(p: Payment, h: House, _ completion: @escaping () -> Void = {}) {
        let db = Firestore.firestore()
        //        print("STARTED")
        db.collection("houses").document(h.id).collection("members").getDocuments { querySnapshot, err in
            //            print("STARTED2")
            guard let docs = querySnapshot?.documents else {
                print("STARTED22")
                print(err.debugDescription)
                return
            }
            //            print("STARTED3")
            var fcms = [String]()
            if p.type == .announcement {
                docs.forEach { qds in
                    let d = qds.data()
                    let f = d["fcm"] as? String ?? ""
                    if f != "" {
                        fcms.append(f)
                    }
                }
                
            } else if p.type == .groupmessage {
                docs.forEach { qds in
                    let d = qds.data()
                    let f = d["fcm"] as? String ?? ""
                    let n = d["name"] as? String ?? ""
                    if f != "" {
                        if p.memo.lowercased().contains("@"+n.lowercased()) || p.memo.lowercased().contains("@everyone") {
                            fcms.append(f)
                        }
                    }
                }
                
            }else if p.type == .request {
                docs.forEach { qds in
                    let d = qds.data()
                    let f = d["fcm"] as? String ?? ""
                    let n = d["name"] as? String ?? ""
                    if f != "" && p.reqfrom.contains(n) {
                        fcms.append(f)
                    }
                }
                
            } else if p.type == .payment {
                docs.forEach { qds in
                    let d = qds.data()
                    let f = d["fcm"] as? String ?? ""
                    let n = d["name"] as? String ?? ""
                    if f != "" && p.to == n {
                        fcms.append(f)
                    }
                }
                
            }
            
            
            //            print("STARTED4")
            
            db.collection("houses").document(h.id).collection("payments").addDocument(data:
                                                                                        ["amount":p.amount, "from":p.from, "reqfrom":p.reqfrom, "type":ptToString(p.type), "special" : p.special, "to":p.to, "time":p.time, "memo":p.memo, "by":UserDefaults.standard.string(forKey: "myId") ?? "noID", "fcm":fcms, "device":UIDevice.modelName]
            ){ _ in
                //            .documentID
                //                print("STARTED 5")
                for member in h.members {
                    self.updateBalances(h: h, m: member)
                }
                //                print("STARTED 6")
                completion()
            }
        }
        
        
    }
    
    
    static func updateBalances(h: House, m: Member) {
        let db = Firestore.firestore()
        if (UserDefaults.standard.string(forKey: "houseId") ?? "") != "" {
            //            print("\n\n\(UserDefaults.standard.string(forKey: "houseId"))\n\nYAYBAL\n\n\(h.payments)\n")
            var owesMe = [String:Float]()
            var iOwe = [String:Float]()
            //            for member in h.members {
            //                owesMe[member.name] = 0
            //                iOwe[member.name] = 0
            //            }
            
            for payment in h.payments
                    .filter({ (p) -> Bool in //iterate thru all payments
                        return p.type != .announcement && p.type != .groupmessage //exclude announcments and group messages
                    })
            {
                if payment.type == .request {
                    //                    print("WASREQ\(payment)")
                    if payment.to == m.name {
                        for member in payment.reqfrom {
                            //they owe me from my request
                            if (owesMe[member] ?? 0) == 0 {
                                owesMe[member] = payment.amount / Float(payment.reqfrom.count)
                            } else {
                                owesMe[member]! += payment.amount / Float(payment.reqfrom.count)
                            }
                        }
                    } else if payment.reqfrom.contains(m.name) {
                        //i owe them from their request
                        if (iOwe[payment.to] ?? 0) == 0 {
                            iOwe[payment.to] = payment.amount / Float(payment.reqfrom.count)
                        } else {
                            iOwe[payment.to]! += payment.amount / Float(payment.reqfrom.count)
                        }
                    }
                } else if payment.type == .payment { //its a payment
                    //                    print("WASPAY\(payment)")
                    if payment.to == m.name {
                        //paid to me
                        if (owesMe[payment.from] ?? 0) == 0 {
                            owesMe[payment.from] =  -payment.amount //they owe me less now
                        } else {
                            owesMe[payment.from]! -=  payment.amount //they owe me less now
                        }
                    } else if payment.from == m.name {
                        //i paid them
                        if (iOwe[payment.to] ?? 0) == 0 {
                            iOwe[payment.to] = -payment.amount//i owe them less now
                        } else {
                            iOwe[payment.to]! -= payment.amount//i owe them less now
                        }
                    }
                }
            }
            //        let id = UserDefaults.standard.string(forKey: "myId")
            //            print("\n\nowes\(owesMe)\n\n\n\(iOwe)\niown")
            iOwe.forEach { (key: String, value: Float) in
                if abs(value - (owesMe[key] ?? Float(0))) < 0.01 {
                    iOwe[key] = 0
                    owesMe[key] = 0
                }
            }
            db.collection("houses").document(UserDefaults.standard.string(forKey: "houseId") ?? "BADHOUSEUPDATEBAL").collection("members").document(m.id).updateData(["owesMe":owesMe, "iOwe":iOwe])
            
        } else {
            print("\n\n\(UserDefaults.standard.string(forKey: "houseId") ?? "HEREEOVERHER")\n\nBALBALBALBAL\n")
        }
    }
    
    
    static func deletePayment(p: Payment, h: House) {
        let db = Firestore.firestore()
        db.collection("houses").document(h.id).collection("payments").document(p.id).delete()
        for member in h.members {
            self.updateBalances(h: h, m: member)
        }
    }
    
    static func deleteAllPayments(h: House) {
        let db = Firestore.firestore()
        db.collection("houses").document(h.id).collection("payments").getDocuments { querySnapshot, err in
            guard let documents = querySnapshot?.documents else {
                return
            }
            
            documents.forEach { qds in
                let data = qds.data()
                let type = data["type"] as? String ?? ""
                
                if type == "payment" || type == "request" {
                    qds.reference.delete()
                }
            }
        }
    }
    
    static func removeMember(m: Member, h: Binding<House>) {
        let db = Firestore.firestore()
        if (UserDefaults.standard.string(forKey: "houseId") ?? "") != "" {
            let docRef = db.collection("houses").document(UserDefaults.standard.string(forKey: "houseId") ?? "BADHOUSERMMEMBER").collection("members").document(m.id)
            docRef.getDocument { (documentSnapshot, err) in
                guard let doc = documentSnapshot else {
                    print("couldn't get doc \(String(describing: err))")
                    return
                }
                db.collection("waitingRoom").document(m.id).setData(doc.data()!)
                db.collection("waitingRoom").document(m.id).updateData(["iOwe" : [String:Float](), "owesMe": [String:Float]()], completion: { (err) in
                    db.collection("houses").document(h.wrappedValue.id).collection("payments").getDocuments { (querySnapshot, err) in
                        guard let documents = querySnapshot?.documents else {
                            print("remove member no payments or something")
                            return
                        }
                        for doc in documents.filter({ (doc) -> Bool in
                            let d = doc.data()
                            let to = (d["to"] ?? "") as! String
                            let from = (d["from"] ?? "") as! String
                            let reqfrom = (d["reqfrom"] ?? [""]) as! [String]
                            let type = d["type"] as? String ?? "unknown"
                            return (to.contains(m.name) || from.contains(m.name) || reqfrom.contains(m.name)) && type != "announcement"
                        }) {
                            db.collection("houses").document(h.wrappedValue.id).collection("payments").document(doc.documentID).delete()
                            h.wrappedValue.members.removeAll { (m) -> Bool in
                                return m.id == doc.documentID
                            }
                        }
                    }
                    docRef.delete()
                    self.sendPayment(p: Payment(from: m.name, time: Int(NSDate().timeIntervalSince1970), memo: "was removed from the group", type: .announcement), h: h.wrappedValue)
                })
            }
            
        }}
    static func swapAdmin(m:Member, h:House, completion: @escaping () -> Void = {}) {
        let db = Firestore.firestore()
        db.collection("houses").document(h.id).collection("members").getDocuments{ (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("no house by id %s, or maybe no members..?", h.id)
                return
            }
            documents.forEach { (doc) in
                let id = doc.documentID
                db.collection("houses").document(h.id).collection("members").document(id).updateData(["admin": id == m.id ? true : false])
                if m.id == id {
                    self.sendPayment(p: Payment(from: m.name, time: Int(NSDate().timeIntervalSince1970), memo: "was made the Group Admin", type: .announcement), h: h)
                    completion()
                }
            }
        }
    }
    static func addToWR(m: Binding<Member>, myId: Binding<String>, h: Binding<House>, _ completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        if myId.wrappedValue == "" {
            db.collection("waitingRoom").addDocument(data: ["name":m.wrappedValue.name, "image":m.wrappedValue.image]).getDocument { (documentSnapshot, err) in
                UserDefaults.standard.set(documentSnapshot?.documentID ?? "wrbs", forKey: "myId")
                UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set(documentSnapshot?.documentID ?? "wrbs", forKey: "myId")
                UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set(documentSnapshot?.data()?["name"] ?? "wrbs", forKey: "myName")
                myId.wrappedValue = documentSnapshot?.documentID ?? "wrbs"
                m.wrappedValue.id = documentSnapshot?.documentID ?? "wrbs"
                m.wrappedValue.home = "waitingRoom"
                h.members.wrappedValue.append(m.wrappedValue)
                UserDefaults.standard.setValue(documentSnapshot?.documentID ?? "wrbs", forKey: "myId")
                UserDefaults.standard.setValue("waitingRoom", forKey: "houseId")
            }
        } else {
            db.collection("waitingRoom").document(myId.wrappedValue).updateData(["name":m.wrappedValue.name, "image":m.wrappedValue.image]){ (err) in
                UserDefaults.standard.set(myId.wrappedValue, forKey: "myId")
                UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set(myId.wrappedValue, forKey: "myId")
                UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set(m.wrappedValue.name, forKey: "myName")
                m.wrappedValue.id = myId.wrappedValue
                m.wrappedValue.home = "waitingRoom"
                h.members.wrappedValue.append(m.wrappedValue)
                UserDefaults.standard.setValue(myId.wrappedValue, forKey: "myId")
                UserDefaults.standard.setValue("waitingRoom", forKey: "houseId")
                
            }
        }
        UserDefaults.standard.set("waitingRoom", forKey: "houseId")
        UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set("waitingRoom", forKey: "houseId")
        
        completion()
    }
    
    static func checkSwitch(h: House, m: Binding<Member>, newGroup: String, newPass: String, showAlert: Binding<Bool>, tapped: Binding<Bool>, msg: Binding<String>, inWR: Binding<Bool>, noProf: Binding<Bool>, showInvite: Binding<Bool>, killHouse: Bool = false, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        
        
        var house = House.empty.id
        //            let startHouse = h.wrappedValue
        db.collection("houses").getDocuments { (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                print(err.debugDescription)
                return
            }
            //                    if h.wrappedValue.id == "waitingRoom" || h.wrappedValue.id == "" {
            documents.forEach { (doc) in
                if doc.documentID == newGroup {
                    house = doc.documentID
                    let d = doc.data()
                    let p = (d["password"] ?? "") as! String
                    
                    if newPass == p {
                        //add this member to house, remove from wr set userdefaults and call for a refresh
                        print("mm \(m.wrappedValue)")
                        print("house \(house)")
                        print("hid \(doc.documentID)")
                        print("mid switching \(m.wrappedValue.id)")
                        //                                    UserDefaults.standard.set(mm.id, forKey: "myId")
                        
                        
                        db.collection("houses").document(house).collection("members").getDocuments { querySnapshot, err in
                            guard let docs = querySnapshot?.documents else {
                                print(err.debugDescription)
                                completion(false)
                                return
                            }
                            if !docs.contains(where: { doc in
                                let data = doc.data()
                                let name = data["name"] ?? ""
                                return name as! String == m.wrappedValue.name
                                
                            }) {
                                //
                                //                                            db.document("houses/\(doc.documentID)/members/\("\(m.wrappedValue.id)")").setData(["name" : mm.name, "image" : mm.image, "home" : doc.documentID, "showStatus": mm.showStatus]) { _ in
                                //                                                h.wrappedValue.id = doc.documentID
                                //                                                h.wrappedValue.members.append(m.wrappedValue)
                                //                                                UserDefaults.standard.set(mm.id, forKey: "myId")
                                //                                                print("ISTHISIT \(doc.documentID)")
                                //                                                UserDefaults.standard.set(doc.documentID, forKey: "houseId")
                                //                                                inWR.wrappedValue = false
                                //                                                db.document("waitingRoom/\(mm.id)").delete()
                                //                                                self.sendPayment(p: Payment(from: mm.name, time: Int(NSDate().timeIntervalSince1970), memo: "joined the group", isAn: true), h: House(id: doc.documentID, name: "", members: [Member](), payments: [Payment](), password: ""))
                                //                                                self.getHouse(h: h, inWR: inWR, noProf: noProf)
                                //                                                showInvite.wrappedValue = false
                                //                                            }
                                //
                                tapped.wrappedValue = true
                                completion(true)
                                
                            } else {
                                print("NAM2\(m.wrappedValue.dict())")
                                msg.wrappedValue = "Member already exists by that name"
                                showAlert.wrappedValue = true
                                tapped.wrappedValue = false
                                completion(false)
                            }
                            
                        }
                        
                        
                        
                    } else {
                        showAlert.wrappedValue = true
                        tapped.wrappedValue = false
                        msg.wrappedValue = "Incorrect password"
                        completion(false)
                    }
                    
                }
            }
            //                    } else {
            //                        showAlert.wrappedValue = true
            //                        tapped.wrappedValue = false
            //                        msg.wrappedValue = "Please leave your current group before opening an invite link"
            //                    }
            
            //            if house == House.empty.id {
            //                showAlert.wrappedValue = true
            //                tapped.wrappedValue = false
            //                msg.wrappedValue = "Group not found"
            //            }
            tapped.wrappedValue = false
        }
        
        
    }
    
    static func switchToHouse(h: Binding<House>, m: Binding<Member>, newGroup: String, newPass: String, showAlert: Binding<Bool>, tapped: Binding<Bool>, msg: Binding<String>, inWR: Binding<Bool>, noProf: Binding<Bool>, showInvite: Binding<Bool>) {
        let db = Firestore.firestore()
        var house = House.empty.id
        //            let startHouse = h.wrappedValue
        db.collection("houses").getDocuments { (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                print(err.debugDescription)
                return
            }
            if h.wrappedValue.id == "waitingRoom" || h.wrappedValue.id == "" {
                documents.forEach { (doc) in
                    if doc.documentID == newGroup {
                        house = doc.documentID
                        let d = doc.data()
                        let p = (d["password"] ?? "") as! String
                        
                        if newPass == p {
                            //add this member to house, remove from wr set userdefaults and call for a refresh
                            let mm = m.wrappedValue
                            print("mm \(mm)")
                            print("house \(house)")
                            print("hid \(doc.documentID)")
                            print("mid switching \(mm.id)")
                            UserDefaults.standard.set(mm.id, forKey: "myId")
                            UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set(mm.id, forKey: "myId")
                            UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set(mm.name, forKey: "myName")
                            
                            
                            db.collection("houses").document(house).collection("members").getDocuments { querySnapshot, err in
                                guard let docs = querySnapshot?.documents else {
                                    print(err.debugDescription)
                                    return
                                }
                                if !docs.contains(where: { doc in
                                    let data = doc.data()
                                    let name = data["name"] ?? ""
                                    return name as! String == m.wrappedValue.name
                                    
                                }) {
                                    //
                                    db.collection("houses").document(doc.documentID).collection("members").document(m.wrappedValue.id).setData(["name" : mm.name, "image" : mm.image, "home" : doc.documentID, "showStatus": mm.showStatus]) { _ in
                                        h.wrappedValue.id = doc.documentID
                                        h.wrappedValue.members.append(m.wrappedValue)
                                        UserDefaults.standard.set(mm.id, forKey: "myId")
                                        UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set(mm.id, forKey: "myId")
                                        UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set(mm.name, forKey: "myName")
                                        print("ISTHISIT \(doc.documentID)")
                                        UserDefaults.standard.set(doc.documentID, forKey: "houseId")
                                        UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set(doc.documentID, forKey: "houseId")
                                        inWR.wrappedValue = false
                                        db.collection("waitingRoom").document(mm.id).delete()
                                        self.sendPayment(p: Payment(from: mm.name, time: Int(NSDate().timeIntervalSince1970), memo: "joined the group", type: .announcement), h: House(id: doc.documentID, name: "", members: [Member](), payments: [Payment](), password: ""))
                                        self.getHouse(h: h, m: m, inWR: inWR, noProf: noProf)
                                        showInvite.wrappedValue = false
                                    }
                                    //
                                    
                                } else {
                                    print("NAM\(m.wrappedValue.name)")
                                    msg.wrappedValue = "Member already exists by that name"
                                    showAlert.wrappedValue = true
                                    tapped.wrappedValue = false
                                }
                                
                            }
                            
                            
                            
                        } else {
                            showAlert.wrappedValue = true
                            tapped.wrappedValue = false
                            msg.wrappedValue = "Incorrect password"
                        }
                        
                    }
                }
            } else {
                showAlert.wrappedValue = true
                tapped.wrappedValue = false
                msg.wrappedValue = "Please leave your current group before opening an invite link"
            }
            
            //            if house == House.empty.id {
            //                showAlert.wrappedValue = true
            //                tapped.wrappedValue = false
            //                msg.wrappedValue = "Group not found"
            //            }
            tapped.wrappedValue = false
        }
        
    }
    
    static func joinHouse(hh: Binding<House>, m: Binding<Member>, hId: String, password: String, showAlert: Binding<Bool>, tapped: Binding<Bool>, msg: Binding<String>, inWR: Binding<Bool>, forceAdmin: Bool = false, approved: Bool = false) {
        let db = Firestore.firestore()
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
                        print("mid \(h.documentID)")
                        UserDefaults.standard.set(mm.id, forKey: "myId")
                        UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set(mm.id, forKey: "myId")
                        UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set(mm.name, forKey: "myName")
                        
                        if mm.id == "" {
                            m.wrappedValue = .empty
                            UserDefaults.standard.set(m.wrappedValue.id, forKey: "myId")
                            UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set(m.wrappedValue.id, forKey: "myId")
                            UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set(m.wrappedValue.name, forKey: "myName")
                            UserDefaults.standard.set(m.wrappedValue.home, forKey: "houseId")
                            UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set(m.wrappedValue.home, forKey: "houseId")
                            inWR.wrappedValue = true
                            print("\n\n\n\n\(mm)\n\n\n\n")
                        } else {
                            
                            db.collection("houses").document(house).collection("members").getDocuments { querySnapshot, err in
                                guard let docs = querySnapshot?.documents else {
                                    print(err.debugDescription)
                                    return
                                }
                                if !docs.contains(where: { doc in
                                    let data = doc.data()
                                    let name = data["name"] ?? ""
                                    return name as! String == m.wrappedValue.name
                                    
                                }) || forceAdmin {
                                    //
                                    db.collection("houses").document(house).collection("members").document(mm.id).setData(["name" : mm.name, "image" : mm.image, "home" : h.documentID, "admin": forceAdmin, "online": true, "showStatus": (UserDefaults.standard.bool(forKey: "statusSet")) ? UserDefaults.standard.bool(forKey: "showStatus") : true]) { _ in
                                        self.getHouse(h: hh, m: m, inWR: inWR, noProf: .constant(false))
                                        db.collection("waitingRoom").document(mm.id).delete()
                                        UserDefaults.standard.set(mm.id, forKey: "myId")
                                        UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set(mm.id, forKey: "myId")
                                        UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set(mm.name, forKey: "myName")
                                        UserDefaults.standard.set(house, forKey: "houseId")
                                        UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set(house, forKey: "houseId")
                                        inWR.wrappedValue = false
                                        self.sendPayment(p: Payment(from: mm.name, time: Int(NSDate().timeIntervalSince1970), memo: "\(forceAdmin ? "created" : "joined") the group", type: .announcement), h: House(id: h.documentID, name: "", members: [Member](), payments: [Payment](), password: ""))
                                    }
                                    //
                                    
                                } else {
                                    print("approved\(approved) \(mm.dict())")
                                    if !approved {
                                        tapped.wrappedValue = false
                                        msg.wrappedValue = "Member already exists by that name"
                                        showAlert.wrappedValue = true
                                    }
                                }
                                
                            }
                            
                            
                        }
                    } else {
                        tapped.wrappedValue = false
                        msg.wrappedValue = "Incorrect password"
                        showAlert.wrappedValue = true
                    }
                    
                }
            }
            if house == House.empty.id {
                tapped.wrappedValue = false
                msg.wrappedValue = "Group not found"
                showAlert.wrappedValue = true
            }
            tapped.wrappedValue = false
        }
    }
    
    static func switchToHouseTwo(h: Binding<House>, m: Binding<Member>, newGroup: String, newPass: String, showAlert: Binding<Bool>, tapped: Binding<Bool>, msg: Binding<String>, inWR: Binding<Bool>, noProf: Binding<Bool>, showInvite: Binding<Bool>) {
        let db = Firestore.firestore()
        UserDefaults.standard.setValue(newGroup, forKey: "houseId")
        m.wrappedValue.home = newGroup
        h.wrappedValue.members = [m.wrappedValue]
        db.collection("houses").document(newGroup).collection("members").document(m.wrappedValue.id).setData(m.wrappedValue.dictimg(), merge: true){ _ in
            h.wrappedValue.id = newGroup
            self.sendPayment(p: Payment(from: m.wrappedValue.name, time: Int(NSDate().timeIntervalSince1970), memo: "joined the group", type: .announcement), h: House(id: newGroup, name: "", members: [Member](), payments: [Payment](), password: ""))
            showInvite.wrappedValue = false
            self.getHouse(h: h, m: m, inWR: .constant(false), noProf: .constant(false), showInvite: showInvite)
            self.maid(m: m, h: h)
        }
        //        self.getMembers(h: h, id: newGroup)
        //        self.getPayments(h: h, id: newGroup)
    }
    
    static func createHouse(hh: Binding<House>, m: Binding<Member>, name: String, password: String, tapped: Binding<Bool>, inWR: Binding<Bool>) {
        let db = Firestore.firestore()
        let id = db.collection("houses").addDocument(data: ["name" : name, "password" : password, "created": Int(NSDate().timeIntervalSince1970)]).documentID
        m.wrappedValue.home = id
        m.wrappedValue.admin = true
        hh.wrappedValue.members = [m.wrappedValue]
        //        db.collection("houses/\(id)/members").addDocument(data: ["admin" : true, "name" : m.wrappedValue.name, "home" : id, "image" : m.wrappedValue.id]) { (err) in
        UserDefaults.standard.set(m.wrappedValue.id, forKey: "myId")
        UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set(m.wrappedValue.id, forKey: "myId")
        UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set(m.wrappedValue.name, forKey: "myName")
        UserDefaults.standard.set(id, forKey: "houseId")
        UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set(id, forKey: "houseId")
        self.joinHouse(hh: hh, m: m, hId: id, password: password, showAlert: .constant(false), tapped: tapped, msg: .constant(""), inWR: inWR, forceAdmin: true)
        //        }
    }
    
    static func deleteAccount(m: Binding<Member>, erase: Bool = false, inWR: Binding<Bool>, transfer: Bool = false, _ completion: @escaping () -> Void = {}) {
        let db = Firestore.firestore()
        if m.wrappedValue.home != "" {
            db.collection("houses").document(m.wrappedValue.home).collection("payments").getDocuments { (querySnapshot, err) in
                guard let documents = querySnapshot?.documents else {
                    print("remove member no payments or something")
                    return
                }
                if erase {
                    for doc in documents {
                        db.collection("houses").document(m.wrappedValue.home).collection("payments").document(doc.documentID).delete()
                    }
                } else {
                    for doc in documents.filter({ (doc) -> Bool in
                        let d = doc.data()
                        let to = (d["to"] ?? "") as! String
                        let from = (d["from"] ?? "") as! String
                        let reqfrom = (d["reqfrom"] ?? [""]) as! [String]
                        let type = d["type"] as? String ?? ""
                        return (to.contains(m.wrappedValue.name) || from.contains(m.wrappedValue.name) || reqfrom.contains(m.wrappedValue.name)) && type != "announcement"
                    }) {
                        db.collection("houses").document(m.wrappedValue.home).collection("payments").document(doc.documentID).delete()
                    }
                }
            }
            db.collection("houses").document(m.wrappedValue.home).collection("members").document(m.wrappedValue.id).delete { (err) in
                if erase {
                    db.collection("houses").document(m.wrappedValue.home).delete()
                } else {
                    self.sendPayment(p: Payment(from: m.wrappedValue.name, time: Int(NSDate().timeIntervalSince1970), memo: "left the group", type: .announcement), h: House(id: m.wrappedValue.home, name: "", members: [Member](), payments: [Payment](), password: ""))
                }
                if !transfer {
                    m.wrappedValue = .empty
                    UserDefaults.standard.set(m.wrappedValue.id, forKey: "myId")
                    UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set(m.wrappedValue.id, forKey: "myId")
                    UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set(m.wrappedValue.name, forKey: "myName")
                    UserDefaults.standard.set(m.wrappedValue.home, forKey: "houseId")
                    UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set(m.wrappedValue.home, forKey: "houseId")
                    inWR.wrappedValue = true
                    m.wrappedValue.id = ""
                }
                completion()
            }
        }
        
    }
    
    static func placeToken(h: Binding<House>, id: String, token: String) {
        let db = Firestore.firestore()
        db.collection("houses").document(h.wrappedValue.id).collection("members").document(id).updateData(["fcm" : token])
    }
    
    static func updateStatus(status: Bool) {
        let db = Firestore.firestore()
        //        let id = UserDefaults.standard.string(forKey: "houseId") ?? ""
        //        let myId = UserDefaults.standard.string(forKey: "myId") ?? ""
        //        print("Status: \(id) \(myId)")
        //        db.document("houses/\(id)/members/\(myId)/").updateData(["online":status, "lastSeen":NSDate().timeIntervalSince1970])
    }
    
    static func toggleShowStatus(s: Bool) {
        let db = Firestore.firestore()
        let id = UserDefaults.standard.string(forKey: "houseId") ?? ""
        let myId = UserDefaults.standard.string(forKey: "myId") ?? ""
        print("Status: \(id) \(myId)")
        db.collection("houses").document(id).collection("members").document(myId).updateData(["showStatus":s])
    }
    
    static func groupNameFromId(id: String, nn: Binding<String>) {
        let db = Firestore.firestore()
        db.collection("houses").document(id).getDocument { docSnap, err in
            guard let doc = docSnap?.get("name") else {
                nn.wrappedValue = "err"
                return
            }
            nn.wrappedValue = doc as! String
        }
    }
    
    static func returnMembers(hId: String, nm: Binding<[Member]>, filter: [String] = [String]()) {
        let db = Firestore.firestore()
        db.collection("houses").document(hId).collection("members").getDocuments { querySnapshot, err in
            guard let docs = querySnapshot?.documents else {
                print(err.debugDescription)
                return
            }
            nm.wrappedValue = docs.map({ q in
                let data = q.data()
                
                let name = data["name"] as? String ?? ""
                let home = data["home"] as? String ?? ""
                let owesMe = data["owesMe"] as? [String : Float] ?? [String : Float]()
                let iOwe = data["iOwe"] as? [String : Float] ?? [String : Float]()
                let image = data["image"] as? String ?? ""
                let admin = data["admin"] as? Bool ?? false
                //                let showStatus = data["showStatus"] as? Bool ?? false
                //                let online = data["online"] as? Bool ?? false
                //                let lastSeen = data["lastSeen"] as? NSNumber ?? 0
                return Member(id: q.documentID, home: home, name: name, owesMe: owesMe, iOwe: iOwe, image: image, admin: admin, showStatus: false)
            }).filter { mem in
                return filter.contains(mem.name) || filter.count == 0
            }
        }
    }
    
    static func maid(m: Binding<Member>, h: Binding<House>) {
        let db = Firestore.firestore()
        db.collection("houses").getDocuments { querySnapshot, err in
            guard let documents = querySnapshot?.documents else {
                print("maiderror")
                return
            }
            documents.forEach { houseq in
                //if needed, here would be where to add delete all empty houses
                //                print("\(qds.documentID) - \(newGroup) -> \(qds.documentID == newGroup)")
                if houseq.documentID != (UserDefaults.standard.string(forKey: "houseId") ?? "") {
                    db.collection("houses").document(houseq.documentID).collection("members").getDocuments { documentSnapshot, err in
                        guard let doc = documentSnapshot?.documents else {
                            print("mainDocError")
                            return
                        }
                        let empt = doc.count == 1
                        doc.forEach { memberq in
                            if memberq.documentID == m.wrappedValue.id {
                                //delete
                                print("FOUNDMAID\(houseq.documentID)\(memberq.documentID)")
                                
                                if empt {
                                    self.getHouse(h: h, m: m, inWR: .constant(false), noProf: .constant(false))
                                    db.collection("houses").document(houseq.documentID).collection("members").getDocuments { qs, e in
                                        qs?.documents.forEach({ qqq in
                                            db.collection("houses").document(houseq.documentID).collection("members").document(qqq.documentID).delete()
                                        })
                                    }
                                    db.collection("houses").document(houseq.documentID).collection("payments").getDocuments { qs, e in
                                        qs?.documents.forEach({ qqq in
                                            db.collection("houses").document(houseq.documentID).collection("payments").document(qqq.documentID).delete()
                                        })
                                        db.collection("houses").document(houseq.documentID).delete()
                                    }
                                } else {
                                    self.getHouse(h: h, m: m, inWR: .constant(false), noProf: .constant(false)){
                                        print("delete time \(houseq.documentID) \(m.wrappedValue.home) \(UserDefaults.standard.string(forKey: "houseId"))")
                                        db.collection("houses").document(houseq.documentID).collection("members").document(memberq.documentID).delete()
                                    }
                                    //delete member
                                    //delete payments
                                    db.collection("houses").document(houseq.documentID).collection("payments").getDocuments { payq, err in
                                        guard let pays = payq?.documents else {
                                            return
                                        }
                                        pays.filter({ payeachfilter in
                                            let d = payeachfilter.data()
                                            let to = (d["to"] ?? "") as! String
                                            let from = (d["from"] ?? "") as! String
                                            let reqfrom = (d["reqfrom"] ?? [""]) as! [String]
                                            let type = d["type"] as? String ?? ""
                                            return (to.contains(m.wrappedValue.name) || from.contains(m.wrappedValue.name) || reqfrom.contains(m.wrappedValue.name)) && type != "announcement"
                                        }).forEach { payeach in
                                            db.collection("houses").document(houseq.documentID).collection("payments").document(payeach.documentID).delete()
                                        }
                                    }
                                    //send payment
                                    var hhh = House.empty
                                    hhh.id = houseq.documentID
                                    self.sendPayment(p: Payment(from: m.wrappedValue.name, time: Int(NSDate().timeIntervalSince1970), memo: "left the group", type: .announcement), h: hhh)
                                }
                                self.getHouse(h: h, m: m, inWR: .constant(false), noProf: .constant(false))
                            }
                        }
                    }
                }
            }
            
            
        }
    }
    static func checkThere(m: Binding<Member>, h: Binding<House>, completion: @escaping (Bool) -> Void) -> EmptyView {
        let db = Firestore.firestore()
        db.collection("houses").document(m.wrappedValue.home).collection("members").getDocuments { memberListSnapshot, err in
            guard let members = memberListSnapshot?.documents else {
                completion(false)
                return
            }
            var has = false
            members.forEach { memberSnap in
                if m.wrappedValue.id == memberSnap.documentID {
                    has = true
                }
            }
            completion(has)
            
        }
        return EmptyView()
    }
    static func removePhoto(m: Binding<Member>) {
        let db = Firestore.firestore()
        db.collection("houses").document(m.wrappedValue.home).collection("members").document(m.wrappedValue.id).updateData(["image":""]){ _ in
            m.wrappedValue.image = ""
        }
    }
    static func changeName(m:Binding<Member>, newName: Binding<String>, completion: @escaping ()->Void = {}) {
        let db = Firestore.firestore()
        let deadname = m.wrappedValue.name
        newName.wrappedValue = newName.wrappedValue.trimmingCharacters(in: .whitespacesAndNewlines)
        db.collection("houses").document(m.wrappedValue.home).collection("members").document(m.wrappedValue.id).updateData(["name":newName.wrappedValue]){ _ in
            //change the name
            //replace all payment names
            db.collection("houses").document(m.wrappedValue.home).collection("payments").getDocuments { allPaymentSnapshot, err in
                guard let allPayments = allPaymentSnapshot?.documents else {
                    return
                }
                allPayments.forEach { paymentSnapshot in
                    let d = paymentSnapshot.data()
                    var reqfrom = d["reqfrom"] as? [String] ?? []
                    var to = d["to"] as? String ?? ""
                    var from = d["from"] as? String ?? ""
                    
                    if reqfrom.contains(deadname) {
                        reqfrom.removeAll { s in
                            return s == deadname
                        }
                        reqfrom.append(newName.wrappedValue)
                    }
                    
                    if to == deadname {
                        to = newName.wrappedValue
                    }
                    
                    if from == deadname {
                        from = newName.wrappedValue
                    }
                    
                    db.collection("houses").document(m.wrappedValue.home).collection("payments").document(paymentSnapshot.documentID).updateData(["reqfrom": reqfrom, "to": to, "from": from, "mute":true, "snooze":String(Date().timeIntervalSince1970)])
                    
                    m.wrappedValue.name = newName.wrappedValue
                    completion()
                }
            }
        }
        
    }
    
    
    //Widget static funcs
    
    static func balanceWidgetMembers(myName: String, myId: String, houseId: String, _ completion: @escaping ([codableMember])->Void ) {
        let db = Firestore.firestore()
        if myName != "" && myId != "" && houseId != "" && houseId != "waitingRoom" {
            print("WIDGETSET")
            db.collection("houses").document(houseId).collection("members").getDocuments { querySnapshot, err in
                guard let docs = querySnapshot?.documents else {
                    return
                }
                //                var members = [codableMember]()
                print(myName+myId+houseId)
                print("\(docs.count) FDFSFD")
                completion(docs.map { queryDocumentSnapshot -> codableMember in
                    let data = queryDocumentSnapshot.data()
                    
                    let name = data["name"] as? String ?? ""
                    let home = data["home"] as? String ?? ""
                    let owesMe = data["owesMe"] as? [String : Float] ?? [String : Float]()
                    let iOwe = data["iOwe"] as? [String : Float] ?? [String : Float]()
                    let image = data["image"] as? String ?? ""
                    let admin = data["admin"] as? Bool ?? false
                    
                    //                    print(name)
                    
                    return codableMember(member: Member(id: queryDocumentSnapshot.documentID, home: home, name: name, owesMe: owesMe, iOwe: iOwe, image: image, admin: admin, showStatus: false, online: false, lastSeen: 0))
                }
                            .filter{ member in
                    return member.id != myId
                })
                //                let encoder = JSONEncoder()
                //                if let encoded = try? encoder.encode(members) {
                //                    UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set(encoded, forKey: "members")
                //                }
                
            }
        } else {
            print(myName+myId+houseId)
            UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set("", forKey: "members")
        }
    }
    
    static func activityWidgetPayments(houseId: String, _ completion: @escaping ([Payment]) -> Void) {
        let db = Firestore.firestore()
        if houseId != "" && houseId != "waitingRoom" {
            print("WIDGETSET2")
            db.collection("houses").document(houseId).collection("payments").getDocuments { querySnapshot, err in
                guard let docs = querySnapshot?.documents else {
                    return
                }
                completion(docs.map({ queryDocumentSnapshot in
                    let data = queryDocumentSnapshot.data()
                    
                    let to = data["to"] as? String ?? ""
                    let time = data["time"] as? NSNumber ?? 0
                    let from = data["from"] as? String ?? ""
                    let reqfrom = data["reqfrom"] as? [String] ?? [""]
                    let amount = data["amount"] as? NSNumber ?? 0
                    let memo = data["memo"] as? String ?? ""
                    let type = data["type"] as? String ?? ""
                    let by = data["by"] as? String ?? ""
                    let special = data["special"] as? String ?? ""
                    
                    return Payment(id: queryDocumentSnapshot.documentID, to: to, from: from, reqfrom: reqfrom, amount: Float(truncating: amount), time: Int(truncating: time), memo: memo, type:stringToPT(type), special: special, by: by)
                }))
            }
        } else {
            print("UHOHHOUSEID \(houseId)")
        }
    }
    
    static func removeFromWr(id: String) {
        let db = Firestore.firestore()
        if id != "" {
            db.collection("waitingRoom").document(id).delete()
        } else {
            print("removed empty id from wr")
        }
    }
    
    static func imgFromId(id: String, img: Binding<String>) {
        let db = Firestore.firestore()
        let house = UserDefaults.standard.string(forKey: "houseId") ?? ""
        
        if house != "" {
            db.collection("houses").document(house).collection("members").document(id).getDocument { ds, err in
                guard let data = ds?.data() else {
                    return
                }
                img.wrappedValue = ((data["image"] ?? "") as! String)
            }
            
        } else {
            img.wrappedValue = ""
        }
    }
    
    static func bindingMemberFromIdsWR(id: String, bm:Binding<Member>) {
        let db = Firestore.firestore()
        db.collection("waitingRoom").document(id).getDocument { ds, error in
            guard let data = ds?.data() else {
                print(error)
                return
            }
            let name = data["name"] as? String ?? ""
            let home = data["home"] as? String ?? ""
            let owesMe = data["owesMe"] as? [String : Float] ?? [String : Float]()
            let iOwe = data["iOwe"] as? [String : Float] ?? [String : Float]()
            let image = data["image"] as? String ?? ""
            let admin = data["admin"] as? Bool ?? false
            bm.wrappedValue = Member(id: id, home: home, name: name, owesMe: owesMe, iOwe: iOwe, image: image, admin: admin, showStatus: false, online: false, lastSeen: 0)
        }
    }
    
    static func optRequest(_ inOrOut: Bool, payment: Payment, name: String) {
        let db = Firestore.firestore()
        db.collectionGroup("payments")
            .getDocuments { qs, err in
                guard let docs = qs?.documents else {return}
                docs.forEach({ qds in
                    
                    let ref = qds.reference
                    let data = qds.data()
                    var reqfrom = data["reqfrom"] as? [String] ?? [String]()
                    if ref.documentID == payment.id {
                        if inOrOut {
                            reqfrom.append(name)
                        } else {
                            reqfrom.removeAll { n in
                                n == name
                            }
                        }
                        var edits = data["edits"] as? [String: String] ?? [String: String]()
                        edits[String(Date().timeIntervalSince1970)] = "\(name) opted \(inOrOut ? "in" : "out")"
                        
                        ref.updateData(["reqfrom": reqfrom, "mute":true, "edits":edits])
                    }
                })
            }
    }
    
    static func updatePaymentSave(payment: Payment, member: Member, nAmount: Float, nMemo: String, nTo: String, nFrom: String) {
        let db = Firestore.firestore()
        //find differences, log edits, update data
        var msg = ""
        var edits = [AnyHashable: Any]()
        var editCount = 0
        if payment.amount == nAmount && payment.memo == nMemo && payment.to == nTo && payment.from == nFrom {
            // nothing changed
        } else {
            msg = "\(member.name) changed: "
            
            if payment.amount != nAmount {
                msg += "Amount from \(String(format: "%.2f", payment.amount)) to \(String(format: "%.2f",nAmount))"
                editCount += 1
                edits["amount"] = nAmount
            }
            
            if payment.memo != nMemo {
                if editCount > 0 {
                    msg += ", "
                }
                msg += "Memo from \(payment.memo) to \(nMemo)"
                editCount += 1
                edits["memo"] = nMemo
            }
            
            if payment.to != nTo {
                if editCount > 0 {
                    msg += ", "
                }
                msg += "To from \(payment.to) to \(nTo)"
                editCount += 1
                edits["to"] = nTo
            }
            
            if payment.from != nFrom {
                if editCount > 0 {
                    msg += ", "
                }
                msg += "From from \(payment.from) to \(nFrom)"
                edits["from"] = nFrom
            }
            var el = payment.editLog
            el[String(Date().timeIntervalSince1970)] = msg
            
            edits["edits"] = el
            
            edits["mute"] = true
            
            //            print(edits)
            //            print("houses/\(member.home)/payments/\(payment.id ?? "ERROR")")
            db.collection("houses").document(member.home).collection("payments").document(payment.id).updateData(edits) { err in
                print(err.debugDescription)
            }
            
        }
    }
    
    static func updateRequestSave(payment: Payment, member: Member, nAmount: Float, nMemo: String, nTo: String, nFrom: [String]) {
        let db = Firestore.firestore()
        //find differences, log edits, update data
        var msg = ""
        var edits = [AnyHashable: Any]()
        var editCount = 0
        if payment.amount == nAmount && payment.memo == nMemo && payment.to == nTo && payment.reqfrom == nFrom {
            // nothing changed
        } else {
            msg = "\(member.name) changed: "
            
            if String(format: "%.2f", payment.amount) != String(format: "%.2f", nAmount) {
                msg += "Amount from \(String(format: "%.2f", payment.amount)) to \(String(format: "%.2f",nAmount))"
                editCount += 1
                edits["amount"] = nAmount
            }
            
            if payment.memo != nMemo {
                if editCount > 0 {
                    msg += ", "
                }
                msg += "Memo from \(payment.memo) to \(nMemo)"
                editCount += 1
                edits["memo"] = nMemo
            }
            
            if payment.to != nTo {
                if editCount > 0 {
                    msg += ", "
                }
                msg += "To from \(payment.to) to \(nTo)"
                editCount += 1
                edits["to"] = nTo
            }
            
            if payment.reqfrom != nFrom {
                if editCount > 0 {
                    msg += ", "
                }
                msg += "From \(findChanges(old: payment.reqfrom, new: nFrom))"
                edits["reqfrom"] = nFrom
            }
            var el = payment.editLog
            el[String(Date().timeIntervalSince1970)] = msg
            
            edits["edits"] = el
            
            edits["mute"] = true
            
            //            print(edits)
            //            print("houses/\(member.home)/payments/\(payment.id ?? "ERROR")")
            db.collection("houses").document(member.home).collection("payments").document(payment.id).updateData(edits) { err in
                print(err.debugDescription)
            }
            
        }
    }
    
    static func updateReactions(payment: Payment, member: Member, reaction: String) {
        let db = Firestore.firestore()
        var newData = [AnyHashable: Any]()
        var el = payment.editLog
        el[member.id] = member.name + "|" + reaction
        
        newData["edits"] = el
        
        newData["mute"] = true
        
        //            print(edits)
        //            print("houses/\(member.home)/payments/\(payment.id ?? "ERROR")")
        db.collection("houses").document(member.home).collection("payments").document(payment.id).updateData(newData) { err in
            print(err.debugDescription)
        }
    }
    
    //    static func updatePayments3() {
    //    let db = Firestore.firestore()
    //        db.collectionGroup("payments")
    //            .getDocuments { qs, err in
    //                guard let docs = qs?.documents else {return}
    //                docs.forEach({ qds in
    //                    let data = qds.data()
    ////
    //                    let an = data["isAn"] as? Bool ?? false
    //                    let gm = data["isGM"] as? Bool ?? false
    //                    let rq = data["isRequest"] as? Bool ?? false
    //
    //                    let id = qds.reference
    ////
    //                    var t: paymentType = .unknown
    //                    if an {
    //                        t = .announcement
    //                    }
    //                    if gm {
    //                        t = .groupmessage
    //                    }
    //                    if rq {
    //                        t = .request
    //                    }
    //                    if !an && !gm && !rq {
    //                        t = .payment
    //                    }
    //                    id.updateData(["type":ptToString(t)]) { err in
    //                        print(err.debugDescription)
    //                    }
    //
    //                })
    //            }
    //    }
    
}

func idfromnamehouse(name: String, house: House) -> String {
    return house.members.first { (m) -> Bool in
        return m.name == name
    }?.id ?? ""
}


func imgtob64(img: UIImage) -> String {
    let data = img.jpegData(compressionQuality: 1)
    return data!.base64EncodedString()
}

func b64toimg(b64: String) -> Image {
    let data = Data(base64Encoded: b64)
    var img = Image(systemName: "gear")
    guard let d = data else {
        print(data ?? "uh oh")
        return img
    }
    img = Image(uiImage: (UIImage(data: d) ?? UIImage(named: "Placeholder"))!)
    return img
}


func settlePayments(_ mems: [Member]) -> [Payment] {
    var ps = [Payment]()
    var members = mems.map { m in
        simpleMember(m)
    }.sorted { a, b in
        a.balance > b.balance
    }
    
    for i in 0..<members.count {
        let from = members[i]
        for j in 0..<members.count {
            if i == j {
                continue
            }
            let to = members[j]
            if (from.balance > 0 && to.balance < 0) {
                let amount = min(from.balance, -to.balance)
                ps.append(Payment(id: UUID().uuidString, to: from.name, from: to.name, amount: amount, time: Int(NSDate().timeIntervalSince1970), memo: "Generated by Quick settle", type: .payment, special: "quicksettle", by: UserDefaults.standard.string(forKey: "myId") ?? "Quick settle"))
                members[i].balance -= amount
                members[j].balance += amount
            }
        }
    }
    
    
    return ps
}

func compactPayments(_ mems: [Member]) -> [Payment] {
    var ps = [Payment]()
    var members = mems.map { m in
        simpleMember(m)
    }.sorted { a, b in
        a.balance > b.balance
    }
    
    for i in 0..<members.count {
        let from = members[i]
        for j in 0..<members.count {
            if i == j {
                continue
            }
            let to = members[j]
            if (from.balance > 0 && to.balance < 0) {
                let amount = min(from.balance, -to.balance)
                ps.append(Payment(id: UUID().uuidString, to: from.name, reqfrom: [to.name], amount: amount, time: Int(NSDate().timeIntervalSince1970), memo: "Generated by Compactor", type: .request, special: "compactor", by: UserDefaults.standard.string(forKey: "myId") ?? "Compactor"))
                members[i].balance -= amount
                members[j].balance += amount
            }
        }
    }
    
    
    return ps
}


func findChanges(old: [String], new: [String]) -> String {
    var added = [String]()
    var removed = [String]()
    
    old.forEach { o in
        if !new.contains(o) {
            removed.append(o)
        }
    }
    
    new.forEach { n in
        if !old.contains(n) {
            added.append(n)
        }
    }
    
    var msg = "by "
    
    if !added.isEmpty {
        msg += "adding " + added.joined(separator: ", ")
    }
    
    if !removed.isEmpty {
        if !added.isEmpty {
            msg += ", and "
        }
        msg += "removing " + removed.joined(separator: ", ")
    }
    
    return msg
    
}
