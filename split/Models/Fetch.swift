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
    @Published var houses = [House]()
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
            
            self.getMembers(h: h, id: id)
            
            h.wrappedValue = House(id: id, name: name, members: h.wrappedValue.members, password: password)
            print(h)
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
                let balance = data["balance"] as? NSNumber ?? 0
                let image = data["image"] as? String ?? ""
                
                return Member(id: q.documentID, name: name, balance: Float(truncating: balance), image: image)
            })
        }
    }
    
}
