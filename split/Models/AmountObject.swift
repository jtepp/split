//
//  AmountObject.swift
//  split
//
//  Created by Jacob Tepperman on 2021-10-09.
//

import SwiftUI

class AmountObject: ObservableObject {
    @Published var values = [IdentifiableFloat]()
    @Published var bulkValues = [String: Float]() //id
    @Published var bulkReceipts = [String : [IdentifiableFloat]]()
    @Published var bulkPeople = [Member]()
    @Published var canCloseOverlay = false
    @Published var showOverlay = false
    @Published var showBulk = false
    @Published var receiptToShow = ""
    @Published var refresh = 0
//    var namespace: Namespace.ID
//    init(_ namespace: Namespace.ID) {
//        self.namespace = namespace
//    }
    func total() -> Float {
        return self.values.reduce(0) { a, b in
            a + b.value
        }
    }
    func clearBulk() {
        self.bulkValues = [String: Float]()
        self.bulkPeople = [Member]()
    }
    
    func clear() {
        self.values = [IdentifiableFloat]()
        self.bulkValues = [String: Float]()
        self.bulkPeople = [Member]()
        self.showBulk = false
        self.showOverlay = false
        self.canCloseOverlay = false
    }
    func placeholder() -> AmountObject {
        let x = AmountObject()//Namespace().wrappedValue)
        x.values = [IdentifiableFloat(value: 10),IdentifiableFloat(value: 20),IdentifiableFloat(value: 30)]
        return x
    }
}

struct IdentifiableFloat: Identifiable {
    let id = UUID()
    var value: Float
}
