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
    private var db = Firestore.firestore()
    
    func getHouse (h: Binding<House>, m: Binding<Member>, inWR: Binding<Bool>, noProf: Binding<Bool>, showInvite: Binding<Bool> = .constant(false), completion: @escaping () -> Void = {}) {
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
                
                
                db.document("houses/"+id).addSnapshotListener { (querySnapshot, error) in
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
                let reqfrom = data["reqfrom"] as? [String] ?? [String]()
                let amount = data["amount"] as? NSNumber ?? 0
                let memo = data["memo"] as? String ?? ""
                let includedSelf = data["includedSelf"] as? Bool ?? false
                let type = data["type"] as? String ?? "unknown"
                let by = data["by"] as? String ?? ""
                let editLog = data["edits"] as? [String] ?? [String]()
                
                
                return Payment(id: q.documentID, to: to, from: from, reqfrom: reqfrom, amount: Float(truncating: amount), time: Int(truncating: time), memo: memo, includedSelf: includedSelf, type: stringToPT(type), by: by, editLog: editLog)
            })
            for member in h.wrappedValue.members {
                self.updateBalances(h: h.wrappedValue, m: member)
            }
        }
    }
    
    func updateImg(img: UIImage, hId: String, myId: String) {
        let id = UserDefaults.standard.string(forKey: "myId")
        print("UPDATEIMG")
        db.document("houses/\(hId)/members/\(id ?? "EMPTYIMG")").updateData(["image":imgtob64(img: img.resized(toWidth: 600)!)])
    }
    
    func sendPayment(p: Payment, h: House, _ completion: @escaping () -> Void = {}) {
//        print("STARTED")
        db.collection("houses/\(h.id)/members").getDocuments { querySnapshot, err in
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
            
            self.db.collection("houses/\(h.id)/payments").addDocument(data:
                                                                        ["amount":p.amount, "from":p.from, "reqfrom":p.reqfrom, "includedSelf" : p.includedSelf, "type":ptToString(p.type), "to":p.to, "time":p.time, "memo":p.memo, "by":UserDefaults.standard.string(forKey: "myId") ?? "noID", "fcm":fcms]
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
    
    
    func updateBalances(h: House, m: Member) {
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
            db.document("houses/\(UserDefaults.standard.string(forKey: "houseId") ?? "BADHOUSEUPDATEBAL")/members/\(m.id)").updateData(["owesMe":owesMe, "iOwe":iOwe])
            
        } else {
            print("\n\n\(UserDefaults.standard.string(forKey: "houseId") ?? "HEREEOVERHER")\n\nBALBALBALBAL\n")
        }
    }
    
    
    func deletePayment(p: Payment, h: House) {
        db.document("houses/\(h.id)/payments/\(p.id!)").delete()
        for member in h.members {
            self.updateBalances(h: h, m: member)
        }
    }
    
    func removeMember(m: Member, h: Binding<House>) {
        if (UserDefaults.standard.string(forKey: "houseId") ?? "") != "" {
            let docRef = db.document("houses/\(UserDefaults.standard.string(forKey: "houseId") ?? "BADHOUSERMMEMBER")/members/\(m.id)")
            docRef.getDocument { (documentSnapshot, err) in
                guard let doc = documentSnapshot else {
                    print("couldn't get doc \(String(describing: err))")
                    return
                }
                self.db.document("waitingRoom/\(m.id)").setData(doc.data()!)
                self.db.document("waitingRoom/\(m.id)").updateData(["iOwe" : [String:Float](), "owesMe": [String:Float]()], completion: { (err) in
                    self.db.collection("houses/\(h.wrappedValue.id)/payments").getDocuments { (querySnapshot, err) in
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
                            self.db.document("houses/\(h.wrappedValue.id)/payments/\(doc.documentID)").delete()
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
    func swapAdmin(m:Member, h:House, completion: @escaping () -> Void = {}){
        db.collection("houses/"+h.id+"/members").getDocuments{ (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("no house by id %s, or maybe no members..?", h.id)
                return
            }
            documents.forEach { (doc) in
                let id = doc.documentID
                self.db.document("houses/\(h.id)/members/\(id)").updateData(["admin": id == m.id ? true : false])
                if m.id == id {
                    self.sendPayment(p: Payment(from: m.name, time: Int(NSDate().timeIntervalSince1970), memo: "was made the Group Admin", type: .announcement), h: h)
                    completion()
                }
            }
        }
    }
    func addToWR(m: Binding<Member>, myId: Binding<String>, h: Binding<House>, _ completion: @escaping () -> Void){
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
            db.document("waitingRoom/\(myId.wrappedValue)").updateData(["name":m.wrappedValue.name, "image":m.wrappedValue.image]){ (err) in
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
    
    func checkSwitch(h: House, m: Binding<Member>, newGroup: String, newPass: String, showAlert: Binding<Bool>, tapped: Binding<Bool>, msg: Binding<String>, inWR: Binding<Bool>, noProf: Binding<Bool>, showInvite: Binding<Bool>, killHouse: Bool = false, completion: @escaping (Bool) -> Void) {
        
        
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
                        
                        
                        self.db.collection("houses/\(house)/members/").getDocuments { querySnapshot, err in
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
                                //                                            self.db.document("houses/\(doc.documentID)/members/\("\(m.wrappedValue.id)")").setData(["name" : mm.name, "image" : mm.image, "home" : doc.documentID, "showStatus": mm.showStatus]) { _ in
                                //                                                h.wrappedValue.id = doc.documentID
                                //                                                h.wrappedValue.members.append(m.wrappedValue)
                                //                                                UserDefaults.standard.set(mm.id, forKey: "myId")
                                //                                                print("ISTHISIT \(doc.documentID)")
                                //                                                UserDefaults.standard.set(doc.documentID, forKey: "houseId")
                                //                                                inWR.wrappedValue = false
                                //                                                self.db.document("waitingRoom/\(mm.id)").delete()
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
    
    func switchToHouse(h: Binding<House>, m: Binding<Member>, newGroup: String, newPass: String, showAlert: Binding<Bool>, tapped: Binding<Bool>, msg: Binding<String>, inWR: Binding<Bool>, noProf: Binding<Bool>, showInvite: Binding<Bool>) {
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
                            
                            
                            self.db.collection("houses/\(house)/members/").getDocuments { querySnapshot, err in
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
                                    self.db.document("houses/\(doc.documentID)/members/\("\(m.wrappedValue.id)")").setData(["name" : mm.name, "image" : mm.image, "home" : doc.documentID, "showStatus": mm.showStatus]) { _ in
                                        h.wrappedValue.id = doc.documentID
                                        h.wrappedValue.members.append(m.wrappedValue)
                                        UserDefaults.standard.set(mm.id, forKey: "myId")
                                        UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set(mm.id, forKey: "myId")
                                        UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set(mm.name, forKey: "myName")
                                        print("ISTHISIT \(doc.documentID)")
                                        UserDefaults.standard.set(doc.documentID, forKey: "houseId")
                                        UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set(doc.documentID, forKey: "houseId")
                                        inWR.wrappedValue = false
                                        self.db.document("waitingRoom/\(mm.id)").delete()
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
    
    func joinHouse(hh: Binding<House>, m: Binding<Member>, hId: String, password: String, showAlert: Binding<Bool>, tapped: Binding<Bool>, msg: Binding<String>, inWR: Binding<Bool>, forceAdmin: Bool = false, approved: Bool = false) {
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
                            
                            self.db.collection("houses/\(house)/members/").getDocuments { querySnapshot, err in
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
                                    self.db.document("houses/\(house)/members/\("\(mm.id)")").setData(["name" : mm.name, "image" : mm.image, "home" : h.documentID, "admin": forceAdmin, "online": true, "showStatus": (UserDefaults.standard.bool(forKey: "statusSet")) ? UserDefaults.standard.bool(forKey: "showStatus") : true]) { _ in
                                        self.getHouse(h: hh, m: m, inWR: inWR, noProf: .constant(false))
                                        self.db.document("waitingRoom/\(mm.id)").delete()
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
    
    func switchToHouseTwo(h: Binding<House>, m: Binding<Member>, newGroup: String, newPass: String, showAlert: Binding<Bool>, tapped: Binding<Bool>, msg: Binding<String>, inWR: Binding<Bool>, noProf: Binding<Bool>, showInvite: Binding<Bool>) {
        UserDefaults.standard.setValue(newGroup, forKey: "houseId")
        m.wrappedValue.home = newGroup
        h.wrappedValue.members = [m.wrappedValue]
        db.document("houses/\(newGroup)/members/\(m.wrappedValue.id)").setData(m.wrappedValue.dictimg(), merge: true){ _ in
            h.wrappedValue.id = newGroup
            self.sendPayment(p: Payment(from: m.wrappedValue.name, time: Int(NSDate().timeIntervalSince1970), memo: "joined the group", type: .announcement), h: House(id: newGroup, name: "", members: [Member](), payments: [Payment](), password: ""))
            showInvite.wrappedValue = false
            self.getHouse(h: h, m: m, inWR: .constant(false), noProf: .constant(false), showInvite: showInvite)
            self.maid(m: m, h: h)
        }
        //        self.getMembers(h: h, id: newGroup)
        //        self.getPayments(h: h, id: newGroup)
    }
    
    func createHouse(hh: Binding<House>, m: Binding<Member>, name: String, password: String, tapped: Binding<Bool>, inWR: Binding<Bool>) {
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
    
    func deleteAccount(m: Binding<Member>, erase: Bool = false, inWR: Binding<Bool>, transfer: Bool = false, _ completion: @escaping () -> Void = {}) {
        if m.wrappedValue.home != "" {
            self.db.collection("houses/\(m.wrappedValue.home)/payments").getDocuments { (querySnapshot, err) in
                guard let documents = querySnapshot?.documents else {
                    print("remove member no payments or something")
                    return
                }
                if erase {
                    for doc in documents {
                        self.db.document("houses/\(m.wrappedValue.home)/payments/\(doc.documentID)").delete()
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
                        self.db.document("houses/\(m.wrappedValue.home)/payments/\(doc.documentID)").delete()
                    }
                }
            }
            db.document("houses/\(m.wrappedValue.home)/members/\(m.wrappedValue.id)").delete { (err) in
                if erase {
                    self.db.document("houses/\(m.wrappedValue.home)").delete()
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
    
    func placeToken(h: Binding<House>, id: String, token: String) {
        db.document("houses/\(h.wrappedValue.id)/members/\(id)").updateData(["fcm" : token])
    }
    
    func updateStatus(status: Bool) {
//        let id = UserDefaults.standard.string(forKey: "houseId") ?? ""
//        let myId = UserDefaults.standard.string(forKey: "myId") ?? ""
//        print("Status: \(id) \(myId)")
//        db.document("houses/\(id)/members/\(myId)/").updateData(["online":status, "lastSeen":NSDate().timeIntervalSince1970])
    }
    
    func toggleShowStatus(s: Bool) {
        let id = UserDefaults.standard.string(forKey: "houseId") ?? ""
        let myId = UserDefaults.standard.string(forKey: "myId") ?? ""
        print("Status: \(id) \(myId)")
        db.document("houses/\(id)/members/\(myId)/").updateData(["showStatus":s])
    }
    
    func groupNameFromId(id: String, nn: Binding<String>) {
        db.document("houses/\(id)").getDocument { docSnap, err in
            guard let doc = docSnap?.get("name") else {
                nn.wrappedValue = "err"
                return
            }
            nn.wrappedValue = doc as! String
        }
    }
    
    func returnMembers(hId: String, nm: Binding<[Member]>, filter: [String] = [String]()) {
        db.collection("houses/\(hId)/members").getDocuments { querySnapshot, err in
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
    
    func maid(m: Binding<Member>, h: Binding<House>) {
        db.collection("houses").getDocuments { querySnapshot, err in
            guard let documents = querySnapshot?.documents else {
                print("maiderror")
                return
            }
            documents.forEach { houseq in
                //if needed, here would be where to add delete all empty houses
                //                print("\(qds.documentID) - \(newGroup) -> \(qds.documentID == newGroup)")
                if houseq.documentID != (UserDefaults.standard.string(forKey: "houseId") ?? "") {
                    self.db.collection("houses/\(houseq.documentID)/members").getDocuments { documentSnapshot, err in
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
                                    self.db.collection("houses/\(houseq.documentID)/members").getDocuments { qs, e in
                                        qs?.documents.forEach({ qqq in
                                            self.db.document("houses/\(houseq.documentID)/members/\(qqq.documentID)").delete()
                                        })
                                    }
                                    self.db.collection("houses/\(houseq.documentID)/payments").getDocuments { qs, e in
                                        qs?.documents.forEach({ qqq in
                                            self.db.document("houses/\(houseq.documentID)/payments/\(qqq.documentID)").delete()
                                        })
                                        self.db.document("houses/\(houseq.documentID)").delete()
                                    }
                                } else {
                                    self.getHouse(h: h, m: m, inWR: .constant(false), noProf: .constant(false)){
                                        print("delete time \(houseq.documentID) \(m.wrappedValue.home) \(UserDefaults.standard.string(forKey: "houseId"))")
                                        self.db.document("houses/\(houseq.documentID)/members/\(memberq.documentID)").delete()
                                    }
                                    //delete member
                                    //delete payments
                                    self.db.collection("houses/\(houseq.documentID)/payments").getDocuments { payq, err in
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
                                            self.db.document("houses/\(houseq.documentID)/payments/\(payeach.documentID)").delete()
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
    func checkThere(m: Binding<Member>, h: Binding<House>, completion: @escaping (Bool) -> Void) -> EmptyView {
        db.collection("houses/\(m.wrappedValue.home)/members").getDocuments { memberListSnapshot, err in
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
    func removePhoto(m: Binding<Member>) {
        db.document("houses/\(m.wrappedValue.home)/members/\(m.wrappedValue.id)").updateData(["image":""]){ _ in
            m.wrappedValue.image = ""
        }
    }
    func changeName(m:Binding<Member>, newName: Binding<String>, completion: @escaping ()->Void = {}) {
        let deadname = m.wrappedValue.name
        newName.wrappedValue = newName.wrappedValue.trimmingCharacters(in: .whitespacesAndNewlines)
        db.document("houses/\(m.wrappedValue.home)/members/\(m.wrappedValue.id)").updateData(["name":newName.wrappedValue]){ _ in
            //change the name
            //replace all payment names
            self.db.collection("houses/\(m.wrappedValue.home)/payments").getDocuments { allPaymentSnapshot, err in
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
                    
                    self.db.document("houses/\(m.wrappedValue.home)/payments/\(paymentSnapshot.documentID)").updateData(["reqfrom": reqfrom, "to": to, "from": from])
                    
                    m.wrappedValue.name = newName.wrappedValue
                    completion()
                }
            }
        }
        
    }
    
    
    //Widget funcs
    
    func balanceWidgetMembers(myName: String, myId: String, houseId: String, _ completion: @escaping ([codableMember])->Void ){
        if myName != "" && myId != "" && houseId != "" && houseId != "waitingRoom" {
            print("WIDGETSET")
            db.collection("houses/\(houseId)/members").getDocuments { querySnapshot, err in
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
    
    func activityWidgetPayments(houseId: String, _ completion: @escaping ([Payment]) -> Void) {
        if houseId != "" && houseId != "waitingRoom" {
            print("WIDGETSET2")
            db.collection("houses/\(houseId)/payments").getDocuments { querySnapshot, err in
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
                    let includedSelf = data["includedSelf"] as? Bool ?? false
                    
                    return Payment(id: queryDocumentSnapshot.documentID, to: to, from: from, reqfrom: reqfrom, amount: Float(truncating: amount), time: Int(truncating: time), memo: memo, includedSelf: includedSelf, type:stringToPT(type), by: by)
                }))
            }
        } else {
            print("UHOHHOUSEID \(houseId)")
        }
    }
    
    func removeFromWr(id: String){
        if id != "" {
        db.document("waitingRoom/\(id)").delete()
        } else {
            print("removed empty id from wr")
        }
    }
    
    func imgFromId(id: String, img: Binding<String>){
        let house = UserDefaults.standard.string(forKey: "houseId") ?? ""
        
        if house != "" {
            db.document("houses/\(house)/members/\(id)").getDocument { ds, err in
                guard let data = ds?.data() else {
                    return
                }
                img.wrappedValue = ((data["image"] ?? "") as! String)
            }
            
        } else {
            img.wrappedValue = ""
        }
    }
    
    func bindingMemberFromIdsWR(id: String, bm:Binding<Member>) {
        db.document("waitingRoom/\(id)").getDocument { ds, error in
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
    
    func optRequest(_ inOrOut: Bool, payment: Payment, name: String) {
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
                        ref.updateData(["reqfrom": reqfrom, "mute":true])
                    }
                })
            }
    }
        
//    func updatePayments3() {
//        db.collectionGroup("payments")
//            .getDocuments { qs, err in
//                guard let docs = qs?.documents else {return}
//                docs.forEach({ qds in
//                    let data = qds.data()
//                    
//                    let an = data["isAn"] as? Bool ?? false
//                    let gm = data["isGM"] as? Bool ?? false
//                    let rq = data["isRequest"] as? Bool ?? false
//                    
//                    let id = qds.reference
//                    
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
//                    id.updateData(["mute": true, "type" : ptToString(t)])
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
                ps.append(Payment(id: UUID().uuidString, to: from.name, from: to.name, amount: amount, time: Int(NSDate().timeIntervalSince1970), memo: "Generated by Quick settle", type: .payment, by: UserDefaults.standard.string(forKey: "myId") ?? "Quick settle"))
                members[i].balance -= amount
                members[j].balance += amount
            }
        }
    }
    
    
    return ps
}
